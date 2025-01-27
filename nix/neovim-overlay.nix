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
    initLuaPre ? "",
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
      initLuaPre
      + ""
      +
      /*
      lua
      */
      ''
        vim.loader.enable()
        vim.opt.rtp:prepend('${../lib}')
      ''
      + ""
      + (builtins.readFile ../nvim/init.lua)
      + ""
      + optionalString (devPlugins != []) (
        /*
        lua
        */
        ''
          local dev_pack_path = vim.fn.stdpath('data') .. '/site/pack/dev'
          local dev_plugins_dir = dev_pack_path .. '/opt'
          local dev_plugin_path
        ''
        + strings.concatMapStringsSep
        "\n"
        (plugin:
          /*
          lua
          */
          ''
            dev_plugin_path = dev_plugins_dir .. '/${plugin.name}'
            if vim.fn.empty(vim.fn.glob(dev_plugin_path)) > 0 then
              vim.notify('Bootstrapping dev plugin ${plugin.name} ...', vim.log.levels.INFO)
              vim.cmd('!${final.git}/bin/git clone ${plugin.url} ' .. dev_plugin_path)
            end
            vim.cmd('packadd! ${plugin.name}')
          '')
        devPlugins
      )
      +
      /*
      lua
      */
      ''
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

    excludeFiles = [
      "indent.vim"
      "menu.vim"
      "mswin.vim"
      "plugin/matchit.vim"
      "plugin/matchparen.vim"
      "plugin/rplugin.vim"
      "plugin/shada.vim"
      "plugin/tohtml.vim"
      "plugin/tutor.vim"
      "plugin/gzip.vim"
      "plugin/tarPlugin.vim"
      "plugin/zipPlugin.vim"
    ];
    postInstallCommands = map (target: "rm -f $out/share/nvim/runtime/${target}") excludeFiles;

    nvim-unwrapped = prev.neovim.overrideAttrs (oa: {
      postInstall = ''
        ${oa.postInstall or ""}
        ${concatStringsSep "\n" postInstallCommands}
      '';
    });
  in
    final.wrapNeovimUnstable nvim-unwrapped (neovimConfig
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
      nvim-ts-context-commentstring
      treesitter-textobjects
      treesitter-context
      rainbow-delimiters-nvim
      (opt vim-matchup)
      vim-wordmotion
      nvim-highlight-colors
      # (withConfig leap "require('leap').set_default_keymaps()")
      flash-nvim
      eyeliner-nvim
      gitlinker
      repeat
      surround
      substitute
      persistence
      nvim-lastplace
      comment
      crates-nvim
      (opt neotest)
      (opt neotest-java)
      neotest-busted
      nio # TODO: Remove when rocks-dev is ready
      jdtls
      live-rename-nvim
      fidget
      (opt illuminate)
      schemastore-nvim
      actions-preview-nvim
      nvim-lint
      telescope_hoogle
      telescope-smart-history
      telescope-zf-native
      (opt telescope)
      todo-comments
      nvim-navic
      lualine
      toggleterm
      (opt harpoon)
      gitsigns
      nvim-bqf
      quicker-nvim
      formatter
      yanky
      statuscol
      nvim-unception
      term-edit-nvim
      oil-nvim
      other-nvim
      which-key-nvim
    ]
    ++ (with prev.vimPlugins; [
      # catppuccin-nvim
      telescope-fzy-native-nvim
      (opt dial-nvim)
      vim-scriptease
      catppuccin-nvim
      (opt (nvim-treesitter.withPlugins (ps:
        with ps; [
          bash
          c
          cpp
          css
          dhall
          diff
          dockerfile
          editorconfig
          gitcommit
          haskell
          haskell_persistent
          html
          java
          jq
          json
          json5
          latex
          lua
          luadoc
          make
          markdown
          markdown_inline
          mermaid
          nix
          nu
          proto
          python
          regex
          rust
          scala
          scheme
          sql
          terraform
          thrift
          toml
          typst
          vim
          vimdoc
          yaml
        ])))
    ]);

  all-plugins =
    base-plugins
    ++ (with final; with final.vimPlugins; [
      haskell-tools-nvim-dev
      neotest-haskell-dev
      telescope-manix
      rustaceanvim
      lz-n
    ]);

  extraPackages = with final; [
    haskellPackages.fast-tags
    nodePackages.vim-language-server
    nodePackages.yaml-language-server
    nodePackages.dockerfile-language-server-nodejs
    # nodePackages.vscode-langservers-extracted
    nodePackages.bash-language-server
    taplo # toml toolkit including a language server
    sqls
    gitu
    jujutsu
  ];

  nvim-dev = mkNeovim {
    appName = "nvim-dev";
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

  nvim-profile = mkNeovim {
    plugins =
      all-plugins
      ++ (with final.nvimPlugins; [
        snacks-nvim
      ]);
    inherit extraPackages;
    initLuaPre = /* lua */ ''
      require('snacks.profiler').startup {}
    '';
  };

  luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
    nvim = final.neovim;
  };
in {
  inherit
    nvim-dev
    nvim-pkg
    nvim-profile
    luarc-json
    ;
}
