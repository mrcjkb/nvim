{inputs}: final: prev:
with final.lib; let
  mkNeovim = {
    appName ? null,
    plugins ? [],
    devPlugins ? [],
    extraPackages ? [],
    resolvedExtraLuaPackages ? [],
    extraPython3Packages ? p: [],
    withPython3 ? true,
    withRuby ? false,
    withNodeJs ? false,
    viAlias ? true,
    vimAlias ? true,
  }: let
    defaultPlugin = {
      plugin = null;
      config = null;
      optional = false;
      runtime = {};
    };

    externalPackages = extraPackages ++ [final.sqlite];

    normalizedPlugins = map (x:
      defaultPlugin
      // (
        if x ? plugin
        then x
        else {plugin = x;}
      ))
    plugins;

    neovimConfig = final.neovimUtils.makeNeovimConfig {
      inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
      plugins = normalizedPlugins;
    };

    nvimConfig = final.stdenv.mkDerivation {
      name = "nvim-config";
      src = ../nvim;

      buildPhase = ''
        mkdir -p $out/nvim
        rm init.lua
      '';

      installPhase = ''
        cp -r * $out/nvim
        rm -r $out/nvim/after
        cp -r after $out/after
        ln -s ${inputs.spell-de-dictionary} $out/nvim/spell/de.utf-8.spl;
        ln -s ${inputs.spell-de-suggestions} $out/nvim/spell/de.utf-8.sug;
      '';
    };

    initLua =
      ''
        vim.loader.enable()
        vim.opt.rtp:prepend('${../lib}')
      ''
      + ""
      + (builtins.readFile ../nvim/init.lua)
      + ""
      + optionalString (devPlugins != []) (
        ''
          local dev_pack_path = vim.fn.stdpath('data') .. '/site/pack/dev'
          local dev_plugins_dir = dev_pack_path .. '/opt'
          local dev_plugin_path
        ''
        + strings.concatMapStringsSep
        "\n"
        (plugin: ''
          dev_plugin_path = dev_plugins_dir .. '/${plugin.name}'
          if vim.fn.empty(vim.fn.glob(dev_plugin_path)) > 0 then
            vim.notify('Bootstrapping dev plugin ${plugin.name} ...', vim.log.levels.INFO)
            vim.cmd('!${final.git}/bin/git clone ${plugin.url} ' .. dev_plugin_path)
          end
          vim.cmd('packadd! ${plugin.name}')
        '')
        devPlugins
      )
      + ''
        vim.opt.rtp:append('${nvimConfig}/nvim')
        vim.opt.rtp:append('${nvimConfig}/after')
      '';

    extraMakeWrapperArgs = builtins.concatStringsSep " " (
      (optional (appName != "nvim" && appName != null && appName != "")
        ''--set NVIM_APPNAME "${appName}"'')
      ++ (optional (externalPackages != [])
        ''--prefix PATH : "${makeBinPath externalPackages}"'')
      ++ [
        ''--set LIBSQLITE_CLIB_PATH "${final.sqlite.out}/lib/libsqlite3.so"''
        ''--set LIBSQLITE "${final.sqlite.out}/lib/libsqlite3.so"''
      ]
    );

    extraMakeWrapperLuaCArgs = optionalString (resolvedExtraLuaPackages != []) ''
      --suffix LUA_CPATH ";" "${
        lib.concatMapStringsSep ";" final.luaPackages.getLuaCPath
        resolvedExtraLuaPackages
      }"'';

    extraMakeWrapperLuaArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''
        --suffix LUA_PATH ";" "${
          concatMapStringsSep ";" final.luaPackages.getLuaPath
          resolvedExtraLuaPackages
        }"'';
  in
    # final.wrapNeovimUnstable inputs.packages.${prev.system}.neovim (neovimConfig
    final.wrapNeovimUnstable final.neovim-nightly (neovimConfig
      // {
        luaRcContent = initLua;
        wrapperArgs =
          escapeShellArgs neovimConfig.wrapperArgs
          + " "
          + extraMakeWrapperArgs
          + " "
          + extraMakeWrapperLuaCArgs
          + " "
          + extraMakeWrapperLuaArgs;
        wrapRc = true;
      });

  opt = drv: {
    plugin = drv;
    optional = true;
  };

  base-plugins = with final.nvimPlugins;
    [
      plenary
      sqlite
      nvim-web-devicons
      diffview
      nvim-ts-context-commentstring
      treesitter-textobjects
      treesitter-context
      wildfire-nvim
      rainbow-delimiters-nvim
      (opt vim-matchup)
      iswap-nvim
      nvim-treesitter
      vim-wordmotion
      nvim-highlight-colors
      # (withConfig leap "require('leap').set_default_keymaps()")
      flash-nvim
      eyeliner-nvim
      neogit
      gitlinker
      repeat
      unimpaired
      surround
      substitute
      persistence
      nvim-lastplace
      comment
      material-theme
      crates-nvim
      (opt neotest)
      (opt neotest-java)
      neotest-busted
      nio # TODO: Remove when rocks-dev is ready
      nvim-dap
      nvim-dap-ui
      jdtls
      nvim-metals
      lsp-status
      lsp_signature
      fidget
      illuminate
      schemastore-nvim
      lspkind-nvim
      actions-preview-nvim
      nvim-lint
      telescope_hoogle
      telescope-smart-history
      telescope
      todo-comments
      fzf-lua
      nvim-navic
      lualine
      toggleterm
      harpoon
      gitsigns
      (opt nvim-bqf)
      formatter
      yanky
      promise-async
      nvim-ufo
      statuscol
      nvim-unception
      tmux-nvim
      hardtime-nvim
      term-edit-nvim
      oil-nvim
      oil-git-status-nvim
      other-nvim
      which-key-nvim
    ]
    ++ (map opt (with final.nvimPlugins; [
      # nvim-cmp and plugins
      cmp-buffer
      cmp-tmux
      cmp-path
      cmp-cmdline
      cmp-cmdline-history
      cmp-nvim-lua
      cmp-nvim-lsp
      cmp-nvim-lsp-document-symbol
      cmp-nvim-lsp-signature-help
      cmp-luasnip
      cmp-luasnip-choice
      cmp-rg
      nvim-cmp
    ]))
    ++ (with prev.vimPlugins; [
      # catppuccin-nvim
      (opt luasnip)
      markdown-preview-nvim
      vim-fugitive
      telescope-fzy-native-nvim
      # neorg
      dial-nvim
      vim-scriptease
    ]);

  all-plugins =
    base-plugins
    ++ (with final; [
      haskell-tools-nvim-dev
      haskell-snippets-nvim
      neotest-haskell-dev
      telescope-manix
      rustaceanvim
    ]);

  extraPackages = with final; [
    haskellPackages.fast-tags
    nodePackages.vim-language-server
    nodePackages.yaml-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.vscode-json-languageserver-bin
    nodePackages.bash-language-server
    taplo # toml toolkit including a language server
    sqls
  ];

  nvim-dev = mkNeovim {
    plugins = base-plugins;
    devPlugins = [
      {
        name = "haskell-tools.nvim";
        url = "git@github.com:mrcjkb/haskell-tools.nvim.git";
      }
      {
        name = "neotest-haskell";
        url = "git@github.com:mrcjkb/neotest-haskell.git";
      }
      {
        name = "haskell-snippets.nvim";
        url = "git@github.com:mrcjkb/haskell-snippets.nvim.git";
      }
      {
        name = "telescope-manix";
        url = "git@github.com:mrcjkb/telescope-manix.git";
      }
      {
        name = "rustaceanvim";
        url = "git@github.com:mrcjkb/rustaceanvim.git";
      }
    ];
    inherit extraPackages;
  };

  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
    nvim = final.neovim-nightly;
    neodev-types = "nightly";
  };
in {
  inherit
    nvim-dev
    nvim-pkg
    luarc-json
    ;
}
