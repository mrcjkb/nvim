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

    externalPackages =
      extraPackages
      ++ (with final; [
        sqlite
        nodePackages.vscode-json-languageserver
      ]);

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

    libExt = final.stdenv.hostPlatform.extensions.sharedLibrary;

    extraMakeWrapperArgs = builtins.concatStringsSep " " (
      (optional (appName != "nvim" && appName != null && appName != "")
        ''--set NVIM_APPNAME "${appName}"'')
      ++ (optional (externalPackages != [])
        ''--prefix PATH : "${makeBinPath externalPackages}"'')
      ++ [
        ''--set LIBSQLITE_CLIB_PATH "${final.sqlite.out}/lib/libsqlite3${libExt}"''
        ''--set LIBSQLITE "${final.sqlite.out}/lib/libsqlite3${libExt}"''
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
      fff-nvim
      todo-comments
      nvim-navic
      lualine
      (opt harpoon)
      gitsigns
      hunk-nvim
      nvim-bqf
      quicker-nvim
      yanky
      statuscol
      nvim-unception
      term-edit-nvim
      oil-nvim
      other-nvim
      which-key-nvim
    ]
    ++ (with prev.vimPlugins; [
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
          graphql
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
    ++ (with final; [
      inputs.haskell-tools.packages.${system}.default
      inputs.neotest-haskell.packages.${system}.default
      # FIXME:
      # inputs.telescope-manix.packages.${system}.default
      final.vimPlugins.telescope-manix
      inputs.rustaceanvim.packages.${system}.default
      inputs.lz-n.packages.${system}.default
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
      {
        name = "lz.n";
        url = "git@github.com:nvim-neorocks/lz.n.git";
      }
      {
        name = "lsp-workspace.nvim";
        url = "git@github.com:mrcjkb/lsp-workspace.nvim.git";
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
    initLuaPre =
      /*
      lua
      */
      ''
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
