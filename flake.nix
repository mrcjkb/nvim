{
  description = "Neovim config";

  nixConfig = {
    extra-substituters = "https://mrcjkb.cachix.org";
    extra-trusted-public-keys = "mrcjkb.cachix.org-1:KhpstvH5GfsuEFOSyGjSTjng8oDecEds7rbrI96tjA4=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    # Plugins
    impatient = {
      url = "github:lewis6991/impatient.nvim";
      flake = false;
    };
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    sqlite = {
      url = "github:kkharji/sqlite.lua";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };
    diffview = {
      # url = "github:sindrets/diffview.nvim";
      url = "github:3699394/diffview.nvim";
      flake = false;
    };
    peek = {
      url = "github:toppair/peek.nvim";
      flake = false;
    };
    glow = {
      url = "github:ellisonleao/glow.nvim";
      flake = false;
    };
    vim-wordmotion = {
      # Vimscript
      url = "github:chaoren/vim-wordmotion";
      flake = false;
    };
    colorizer = {
      url = "github:NvChad/nvim-colorizer.lua";
      flake = false;
    };
    leap = {
      url = "github:ggandor/leap.nvim";
      flake = false;
    };
    nvim-treehopper = {
      url = "github:mfussenegger/nvim-treehopper";
      flake = false;
    };
    eyeliner-nvim = {
      url = "github:jinh0/eyeliner.nvim";
      flake = false;
    };
    vim-textobj-user = {
      # Vimscript
      # User-defined textobjects
      url = "github:kana/vim-textobj-user";
      flake = false;
    };
    neogit = {
      url = "github:TimUntersberger/neogit";
      flake = false;
    };
    gitlinker = {
      url = "github:ruifm/gitlinker.nvim";
      flake = false;
    };
    repeat = {
      url = "github:tpope/vim-repeat";
      flake = false;
    };
    unimpaired = {
      # XXX: Do need this?
      url = "github:tpope/vim-unimpaired";
      flake = false;
    };
    surround = {
      url = "github:kylechui/nvim-surround";
      flake = false;
    };
    persistence = {
      url = "github:folke/persistence.nvim";
      flake = false;
    };
    comment = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };
    material-theme = {
      url = "github:marko-cerovac/material.nvim";
      flake = false;
    };
    neotest = {
      url = "github:nvim-neotest/neotest";
      flake = false;
    };
    neotest-python = {
      url = "github:nvim-neotest/neotest-python";
      flake = false;
    };
    neotest-plenary = {
      url = "github:nvim-neotest/neotest-plenary";
      flake = false;
    };
    neotest-rust = {
      url = "github:rouge8/neotest-rust";
      flake = false;
    };
    neoconf-nvim = {
      url = "github:folke/neoconf.nvim";
      flake = false;
    };
    schemastore-nvim = {
      url = "github:b0o/SchemaStore.nvim";
      flake = false;
    };
    lspconfig = {
      # XXX: Do I need this?
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };
    inlay-hints = {
      url = "github:simrat39/inlay-hints.nvim";
      flake = false;
    };
    jdtls = {
      # FIXME: Update setup in dotfiles
      url = "github:mfussenegger/nvim-jdtls";
      flake = false;
    };
    neodev-nvim = {
      url = "github:folke/neodev.nvim";
      flake = false;
    };
    femaco = {
      url = "github:AckslD/nvim-FeMaco.lua";
      flake = false;
    };
    nvim-dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    nvim-dap-ui = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };
    nvim-dap-virtual-text = {
      url = "github:theHamsta/nvim-dap-virtual-text";
      flake = false;
    };
    one-small-step-for-vimkind = {
      url = "github:jbyuki/one-small-step-for-vimkind";
      flake = false;
    };
    lsp-status = {
      url = "github:nvim-lua/lsp-status.nvim";
      flake = false;
    };
    lsp_signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    nvim-lsp-selection-range = {
      url = "github:camilledejoye/nvim-lsp-selection-range";
      flake = false;
    };
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };
    fidget = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    illuminate = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-cmdline = {
      url = "github:hrsh7th/cmp-cmdline";
      flake = false;
    };
    cmp-cmdline-history = {
      url = "github:dmitmel/cmp-cmdline-history";
      flake = false;
    };
    cmp-nvim-lua = {
      url = "github:hrsh7th/cmp-nvim-lua";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-nvim-lsp-document-symbol = {
      url = "github:hrsh7th/cmp-nvim-lsp-document-symbol";
      flake = false;
    };
    cmp-nvim-lsp-signature-help = {
      url = "github:hrsh7th/cmp-nvim-lsp-signature-help";
      flake = false;
    };
    cmp-omni = {
      url = "github:hrsh7th/cmp-omni";
      flake = false;
    };
    cmp-nvim-ultisnips = {
      # TODO: Replace with LuaSnip
      url = "github:quangnguyen30192/cmp-nvim-ultisnips";
      flake = false;
    };
    cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    cmp-git = {
      url = "github:petertriho/cmp-git";
      flake = false;
    };
    cmp-rg = {
      url = "github:lukas-reineke/cmp-rg";
      flake = false;
    };
    lspkind-nvim = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    cmp-dap = {
      url = "github:rcarriga/cmp-dap";
      flake = false;
    };
    cmp-conventionalcommits = {
      url = "github:davidsierradz/cmp-conventionalcommits";
      flake = false;
    };
    treesitter-playground = {
      url = "github:nvim-treesitter/playground";
      flake = false;
    };
    treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects";
      flake = false;
    };
    treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };
    nvim-ts-context-commentstring = {
      url = "github:JoosepAlviste/nvim-ts-context-commentstring";
      flake = false;
    };
    treesitter-refactor = {
      url = "github:nvim-treesitter/nvim-treesitter-refactor";
      flake = false;
    };
    nvim-ts-rainbow2 = {
      url = "github:HiPhish/nvim-ts-rainbow2";
      flake = false;
    };
    nvim-lint = {
      url = "github:mfussenegger/nvim-lint";
      flake = false;
    };
    ultisnips = {
      url = "github:SirVer/ultisnips";
      flake = false;
    };
    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    project = {
      url = "github:ahmedkhalf/project.nvim";
      flake = false;
    };
    telescope = {
      url = "github:nvim-telescope/telescope.nvim/0.1.x";
      flake = false;
    };
    telescope_hoogle = {
      url = "github:luc-tielen/telescope_hoogle";
      flake = false;
    };
    telescope-smart-history = {
      url = "github:nvim-telescope/telescope-smart-history.nvim";
      flake = false;
    };
    todo-comments = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };
    fzf-lua = {
      url = "github:ibhagwan/fzf-lua";
      flake = false;
    };
    lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };
    nvim-gps = {
      url = "github:SmiteshP/nvim-gps";
      flake = false;
    };
    rnvimr = {
      url = "github:kevinhwang91/rnvimr";
      flake = false;
    };
    dirbuf = {
      url = "github:elihunter173/dirbuf.nvim";
      flake = false;
    };
    toggleterm = {
      url = "github:akinsho/toggleterm.nvim";
      flake = false;
    };
    harpoon = {
      url = "github:ThePrimeagen/harpoon";
      flake = false;
    };
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    nvim-bqf = {
      url = "github:kevinhwang91/nvim-bqf";
      flake = false;
    };
    formatter = {
      url = "github:mhartington/formatter.nvim";
      flake = false;
    };
    yanky = {
      url = "github:gbprod/yanky.nvim";
      flake = false;
    };
    iron = {
      url = "github:hkupty/iron.nvim";
      flake = false;
    };
    venn = {
      url = "github:jbyuki/venn.nvim";
      flake = false;
    };
    promise-async = {
      url = "github:kevinhwang91/promise-async";
      flake = false;
    };
    nvim-ufo = {
      url = "github:kevinhwang91/nvim-ufo";
      flake = false;
    };
    statuscol = {
      url = "github:luukvbaal/statuscol.nvim";
      flake = false;
    };
    nvim-unception = {
      url = "github:samjwill/nvim-unception";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    neovim-nightly-overlay,
    flake-utils,
    pre-commit-hooks,
    ...
  }: let
    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    plugin-overlay = import ./nix/plugin-overlay.nix {inherit inputs;};
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          neovim-nightly-overlay.overlay
        ];
      };
      shell = pkgs.mkShell {
        name = "nvim-config-devShell";
        buildInputs =
          (with pkgs; [
            lua-language-server
          ])
          ++ (with pre-commit-hooks.packages.${system}; [
            alejandra
            stylua
            luacheck
          ]);
        shellHook = ''
          ${self.checks.${system}.pre-commit-check.shellHook}
        '';
      };
      pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = self;
        hooks = {
          alejandra.enable = true;
          stylua.enable = true;
          luacheck.enable = true;
        };
      };
    in {
      packages = rec {
        default = neovim-nightly;
        inherit (pkgs) neovim-nightly;
      };
      devShells = {
        default = shell;
      };
      checks = {
        inherit pre-commit-check;
      };
    })
    // {
      nixosModules.default = {
        pkgs,
        lib,
        defaultUser,
        ...
      }: {
        imports = [
          ./nix/nvim_module.nix
        ];
        programs.nvim = let
          schedule = config: ''
            vim.schedule(function()
              ${config}
            end)
          '';
          withConfig = plugin: config: {
            inherit plugin config;
          };
          withLuaModule = plugin: module: withConfig plugin "require('${module}')";
          withScheduledLuaModule = plugin: module: withConfig plugin (schedule "require('${module}')");
          withLuaSetup = plugin: module: withConfig plugin "require('${module}').setup()";
          withDefaultLuaSetup = plugin: module: withConfig plugin "require('${module}').setup {}";
          withScheduledLuaSetup = plugin: module: withConfig plugin (schedule "require('${module}').setup()");
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
          extraPackages = with pkgs.unstable; [
            (python3.withPackages (ps:
              with ps; [
                pynvim
                python-lsp-server
                pylsp-mypy
                flake8
              ]))
            haskellPackages.hoogle
            haskellPackages.hlint
            haskell-language-server
            haskellPackages.haskell-debug-adapter
            haskellPackages.ghci-dap
            haskellPackages.fast-tags # Fast tag generation
            nil
            dhall-lsp-server
            rust-analyzer
            taplo # toml toolkit including a language server
            lua-language-server
            nodePackages.vim-language-server
            nodePackages.yaml-language-server
            nodePackages.dockerfile-language-server-nodejs
            nodePackages.vscode-json-languageserver-bin
            nodePackages.bash-language-server
            nodePackages.markdownlint-cli
            lua51Packages.luacheck
            sqls
            jdt-language-server
            glow # Dependency of glow.nvim
            bat
            ueberzug # Display images in terminal
            feh # Fast and light image viewer
            fzf # Fuzzy search
            xclip # Required so that neovim compiles with clipboard support
            ripgrep
            silver-searcher # Ag
            fd
            stylua
            ctags
            texlab
            deno # Needed by peek.nvim
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
            {
              name = "lsp-inject.nvim";
              url = "git@github.com:mrcjkb/lsp-inject.nvim.git";
            }
          ];
          plugins = with pkgs.nvimPlugins; [
            (withLuaModule impatient "impatient")
            plenary
            (withConfig sqlite "vim.g.sqlite_clib_path = require('luv').os_getenv('LIBSQLITE')")
            nvim-web-devicons
            diffview
            nvim-ts-context-commentstring
            treesitter-playground
            treesitter-textobjects
            treesitter-context
            treesitter-refactor
            nvim-ts-rainbow2
            (withLuaModule pkgs.unstable.vimPlugins.nvim-treesitter.withAllGrammars "plugin.treesitter")
            # TODO: Package with deno build
            (withLuaModule peek "plugin.peek")
            glow # TODO: Add glow dependency to overlay
            (withLuaModule vim-wordmotion "plugin.wordmotion")
            (withScheduledLuaSetup colorizer "colorizer")
            (withConfig leap "require('leap').set_default_keymaps()")
            (withLuaModule nvim-treehopper "plugin.treehopper")
            (withLuaModule eyeliner-nvim "plugin.eyeliner")
            vim-textobj-user
            pkgs.unstable.vimPlugins.vim-fugitive
            (withLuaModule neogit "plugin.neogit")
            (withLuaModule gitlinker "plugin.gitlinker")
            repeat
            unimpaired
            (withLuaSetup surround "nvim-surround")
            (withLuaModule persistence "plugin.persistence")
            (withLuaSetup comment "Comment")
            (withLuaModule material-theme "plugin.theme")
            neotest-python
            neotest-plenary
            neotest-rust
            (withLuaModule neotest "plugin.neotest")
            (withLuaModule nvim-dap "plugin.dap")
            nvim-dap-ui
            nvim-dap-virtual-text
            (withLuaModule neodev-nvim "plugin.neodev")
            (withLuaModule femaco "plugin.femaco")
            jdtls
            lsp-status
            lsp_signature
            nvim-lsp-selection-range
            nvim-lightbulb
            rust-tools
            inlay-hints
            one-small-step-for-vimkind
            fidget
            illuminate
            (withLuaSetup neoconf-nvim "neoconf")
            schemastore-nvim
            lspconfig
            cmp-buffer
            cmp-path
            cmp-cmdline
            cmp-cmdline-history
            cmp-nvim-lua
            cmp-nvim-lsp
            cmp-nvim-lsp-document-symbol
            cmp-nvim-lsp-signature-help
            cmp-omni
            cmp-nvim-ultisnips
            cmp-luasnip
            cmp-git
            cmp-rg
            lspkind-nvim
            cmp-dap
            cmp-conventionalcommits
            (withScheduledLuaModule nvim-cmp "plugin.completion")
            (withLuaModule nvim-lint "plugin.lint")
            (withConfig ultisnips "vim.g.UltiSnipsSnippetDirectories = { 'UltiSnips', 'ultisnips' }")
            cmp-luasnip
            (withLuaModule luasnip "plugin.luasnip")
            (withLuaModule project "plugin.project")
            telescope_hoogle
            pkgs.unstable.vimPlugins.telescope-fzy-native-nvim
            telescope-smart-history
            (withScheduledLuaModule telescope "plugin.telescope")
            (withLuaSetup todo-comments "todo-comments")
            fzf-lua
            nvim-gps
            (withLuaModule lualine "plugin.lualine")
            (withLuaModule rnvimr "plugin.rnvimr")
            (withDefaultLuaSetup dirbuf "dirbuf")
            (withLuaModule toggleterm "plugin.toggleterm")
            (withLuaModule harpoon "plugin.harpoon")
            (withLuaModule gitsigns "plugin.gitsigns")
            nvim-bqf
            (withLuaModule formatter "plugin.formatter")
            (withLuaModule yanky "plugin.yanky")
            (withLuaModule iron "plugin.repl")
            (withLuaModule venn "venn")
            promise-async
            (withLuaModule nvim-ufo "plugin.ufo")
            (withLuaModule statuscol "plugin.statuscol")
            nvim-unception
          ];
        };
        home-manager.sharedModules = [
          {
            xdg.configFile."nvim" = {
              source = ./nvim;
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
            LIBSQLITE_CLIB_PATH = "${unstable.sqlite.out}/lib/libsqlite3.so";
            LIBSQLITE = LIBSQLITE_CLIB_PATH; # Expected by sqlite plugin
          };
        };
      };
    };
}
