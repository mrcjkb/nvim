final: prev:
with final.pkgs.lib; let
  pkgs = final.pkgs;

  mkNeovim = {
    appName ? null,
    wrapRc ? true,
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

    externalPackages = extraPackages ++ [pkgs.sqlite];

    normalizedPlugins = map (x:
      defaultPlugin
      // (
        if x ? plugin
        then x
        else {plugin = x;}
      ))
    plugins;

    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      inherit extraPython3Packages withPython3 withRuby withNodeJs viAlias vimAlias;
      plugins = normalizedPlugins;
    };

    initSrc = ../nvim;

    customRC =
      ''
        vim.loader.enable()
        local dev_pack_path = vim.fn.stdpath('data') .. '/site/pack/dev'
        local dev_plugins_dir = dev_pack_path .. '/opt'
        local dev_plugin_path
      ''
      + optionalString (devPlugins != []) (
        strings.concatMapStringsSep
        "\n"
        (plugin: ''
          dev_plugin_path = dev_plugins_dir .. '/${plugin.name}'
          if vim.fn.empty(vim.fn.glob(dev_plugin_path)) > 0 then
            vim.notify('Bootstrapping dev plugin ${plugin.name} ...', vim.log.levels.INFO)
            vim.cmd('!${pkgs.git}/bin/git clone ${plugin.url} ' .. dev_plugin_path)
          end
          vim.cmd.packadd('${plugin.name}')
        '')
        devPlugins
      )
      + ''
        vim.opt.rtp:prepend('${initSrc}')
        vim.opt.rtp:prepend('${initSrc}/lua')
        require('mrcjk')
        require('plugin')
      ''
      + neovimConfig.neovimRcContent;

    extraMakeWrapperArgs = builtins.concatStringsSep " " (
      (optional (appName != "nvim" && appName != null && appName != "")
        ''--set NVIM_APPNAME "${appName}"'')
      ++ (optional (externalPackages != [])
        ''--prefix PATH : "${makeBinPath externalPackages}"'')
      ++ (optional wrapRc
        ''--add-flags -u --add-flags "${pkgs.writeText "init.lua" customRC}"'')
      ++ [
        ''--set LIBSQLITE_CLIB_PATH "${pkgs.sqlite.out}/lib/libsqlite3.so"''
        ''--set LIBSQLITE "${pkgs.sqlite.out}/lib/libsqlite3.so"''
      ]
    );

    extraMakeWrapperLuaCArgs = optionalString (resolvedExtraLuaPackages != []) ''
      --suffix LUA_CPATH ";" "${
        lib.concatMapStringsSep ";" pkgs.luaPackages.getLuaCPath
        resolvedExtraLuaPackages
      }"'';

    extraMakeWrapperLuaArgs =
      optionalString (resolvedExtraLuaPackages != [])
      ''
        --suffix LUA_PATH ";" "${
          concatMapStringsSep ";" pkgs.luaPackages.getLuaPath
          resolvedExtraLuaPackages
        }"'';
  in
    pkgs.wrapNeovimUnstable pkgs.neovim-nightly (neovimConfig
      // {
        wrapperArgs =
          escapeShellArgs neovimConfig.wrapperArgs
          + " "
          + extraMakeWrapperArgs
          + " "
          + extraMakeWrapperLuaCArgs
          + " "
          + extraMakeWrapperLuaArgs;
        wrapRc = false;
      });

  all-plugins = with pkgs.nvimPlugins;
    [
      plenary
      sqlite
      nvim-web-devicons
      diffview
      nvim-ts-context-commentstring
      treesitter-playground
      treesitter-textobjects
      treesitter-context
      treesitter-refactor
      wildfire-nvim
      rainbow-delimiters-nvim
      vim-matchup
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
      vim-wordmotion
      colorizer
      # (withConfig leap "require('leap').set_default_keymaps()")
      flash-nvim
      eyeliner-nvim
      vim-textobj-user
      pkgs.vimPlugins.vim-fugitive
      neogit
      gitlinker
      repeat
      unimpaired
      surround
      persistence
      nvim-lastplace
      comment
      material-theme
      neotest-rust
      neotest
      nvim-dap
      nvim-dap-ui
      nvim-dap-virtual-text
      neodev-nvim
      jdtls
      lsp-status
      lsp_signature
      nvim-lsp-selection-range
      nvim-lightbulb
      rust-tools
      inlay-hints
      fidget
      illuminate
      neoconf-nvim
      schemastore-nvim
      lspconfig
      lspkind-nvim
      nvim-code-action-menu
      nvim-lint
      luasnip
      project
      telescope_hoogle
      pkgs.vimPlugins.telescope-fzy-native-nvim
      telescope-smart-history
      telescope
      todo-comments
      fzf-lua
      nvim-gps
      lualine
      rnvimr
      toggleterm
      harpoon
      gitsigns
      nvim-bqf
      formatter
      yanky
      promise-async
      nvim-ufo
      statuscol
      nvim-unception
      tmux-nvim
      hardtime-nvim
      term-edit-nvim
      mini-files
    ]
    ++ [
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
      cmp-omni
      cmp-luasnip
      cmp-luasnip-choice
      cmp-git
      cmp-rg
      cmp-dap
      nvim-cmp
    ];

  nvim-dev = mkNeovim {
    plugins = all-plugins;
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
    ];
  };

  nvim-pkg = mkNeovim {
    plugins =
      all-plugins
      ++ (with pkgs; [
        haskell-tools-nvim-dev
        haskell-snippets-nvim
        neotest-haskell-dev
        telescope-manix
      ]);
  };
in {
  inherit
    nvim-dev
    nvim-pkg
    ;
}
