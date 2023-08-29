{
  neovim-nightly-overlay,
  plugin-overlay,
}: {
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./nvim-module.nix
  ];
  programs.nvim = let
    schedule = config: ''
      vim.schedule(function()
        ${config}
      end)
    '';
    withConfig = {
      plugin,
      config,
      optional ? false,
    }: {
      inherit plugin config optional;
    };
    withLuaModule = plugin: module:
      withConfig {
        inherit plugin;
        config = "require('${module}')";
      };
    optionalPlugin = plugin: {
      inherit plugin;
      optional = true;
    };
    withLazyPluginModule = plugin: module:
      withConfig {
        inherit plugin;
        config = "require('plugin.${module}')";
        optional = true;
      };
    withScheduledLuaModule = plugin: module:
      withConfig {
        inherit plugin;
        config = schedule "require('${module}')";
      };
    withLuaSetup = plugin: module:
      withConfig {
        inherit plugin;
        config = "require('${module}').setup()";
      };
    withScheduledLuaSetup = plugin: module:
      withConfig {
        inherit plugin;
        config = schedule "require('${module}').setup()";
      };
  in {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;
    # extraPython3Packages = ps:
    #   with ps; [
    #     pynvim
    #     python-lsp-server
    #     pylsp-mypy
    #     flake8
    #   ];
    extraPackages = with pkgs; [
      (python3.withPackages (ps:
        with ps; [
          pynvim
          python-lsp-server
          pylsp-mypy
          flake8
          ueberzug
        ]))
      haskellPackages.fast-tags # Fast tag generation
      bat
      ueberzug # Display images in terminal
      feh # Fast and light image viewer
      fzf # Fuzzy search
      ripgrep
      silver-searcher # Ag
      fd
      ctags
    ];
    extraConfigLua = ''
      require('mrcjk')
    '';
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
    plugins = with pkgs.nvimPlugins;
      [
        plenary
        (withConfig {
          plugin = sqlite;
          config = "vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')";
        })
        nvim-web-devicons
        (withLuaModule diffview "plugin.diffview")
        nvim-ts-context-commentstring
        treesitter-playground
        treesitter-textobjects
        treesitter-context
        treesitter-refactor
        (withLuaSetup wildfire-nvim "wildfire")
        rainbow-delimiters-nvim
        vim-matchup
        (withLuaModule pkgs.vimPlugins.nvim-treesitter.withAllGrammars "plugin.treesitter")
        # TODO: Package with deno build
        (withLuaModule peek "plugin.peek")
        (withLuaModule vim-wordmotion "plugin.wordmotion")
        (withScheduledLuaSetup colorizer "colorizer")
        # (withConfig leap "require('leap').set_default_keymaps()")
        (withLuaModule flash-nvim "plugin.flash")
        (withLuaModule eyeliner-nvim "plugin.eyeliner")
        vim-textobj-user
        pkgs.vimPlugins.vim-fugitive
        (withLuaModule neogit "plugin.neogit")
        (withLuaModule gitlinker "plugin.gitlinker")
        repeat
        unimpaired
        (withLuaSetup surround "nvim-surround")
        (withLuaModule persistence "plugin.persistence")
        (withLuaSetup nvim-lastplace "nvim-lastplace")
        (withLuaSetup comment "Comment")
        (withLuaModule material-theme "plugin.theme")
        neotest-rust
        (withLuaModule neotest "plugin.neotest")
        (withLuaModule nvim-dap "plugin.dap")
        nvim-dap-ui
        nvim-dap-virtual-text
        (withLuaModule neodev-nvim "plugin.neodev")
        jdtls
        lsp-status
        lsp_signature
        nvim-lsp-selection-range
        nvim-lightbulb
        rust-tools
        inlay-hints
        fidget
        (withLuaModule illuminate "plugin.illuminate")
        (withLuaSetup neoconf-nvim "neoconf")
        schemastore-nvim
        lspconfig
        lspkind-nvim
        nvim-code-action-menu
        (withLuaModule nvim-lint "plugin.lint")
        (withLuaModule luasnip "plugin.luasnip")
        (withLuaModule project "plugin.project")
        telescope_hoogle
        pkgs.vimPlugins.telescope-fzy-native-nvim
        telescope-smart-history
        (withScheduledLuaModule telescope "plugin.telescope")
        (withLuaSetup todo-comments "todo-comments")
        fzf-lua
        nvim-gps
        (withLuaModule lualine "plugin.lualine")
        (withLuaModule rnvimr "plugin.rnvimr")
        (withLuaModule toggleterm "plugin.toggleterm")
        (withLuaModule harpoon "plugin.harpoon")
        (withLuaModule gitsigns "plugin.gitsigns")
        nvim-bqf
        (withLuaModule formatter "plugin.formatter")
        (withLuaModule yanky "plugin.yanky")
        promise-async
        (withLuaModule nvim-ufo "plugin.ufo")
        (withLuaModule statuscol "plugin.statuscol")
        nvim-unception
        (withLuaSetup tmux-nvim "tmux")
        (withLuaModule hardtime-nvim "plugin.hardtime")
        (withLuaModule term-edit-nvim "plugin.term-edit")
        (withLuaModule mini-files "plugin.files")
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
        (withScheduledLuaModule nvim-cmp "plugin.completion")
      ];
  };
  home-manager.sharedModules = [
    {
      xdg.configFile."nvim" = {
        source = ../nvim;
        recursive = true;
      };
    }
  ];

  nixpkgs = {
    overlays = [
      neovim-nightly-overlay.overlay
      plugin-overlay
    ];
  };

  environment = with pkgs; {
    sessionVariables = rec {
      LIBSQLITE_CLIB_PATH = "${sqlite.out}/lib/libsqlite3.so";
      LIBSQLITE = LIBSQLITE_CLIB_PATH; # Expected by sqlite plugin
    };
  };
}
