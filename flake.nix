{
  description = "Neovim config";

  nixConfig = {
    extra-substituters = "https://mrcjkb.cachix.org";
    extra-trusted-public-keys = "mrcjkb.cachix.org-1:KhpstvH5GfsuEFOSyGjSTjng8oDecEds7rbrI96tjA4=";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neorocks = {
      url = "github:nvim-neorocks/neorocks";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    # Plugins
    haskell-tools = {
      url = "github:mrcjkb/haskell-tools.nvim";
    };
    haskell-snippets = {
      url = "github:mrcjkb/haskell-snippets.nvim";
    };
    neotest-haskell = {
      url = "github:mrcjkb/neotest-haskell";
    };
    telescope-manix = {
      url = "github:mrcjkb/telescope-manix";
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
      url = "github:sindrets/diffview.nvim";
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
    # leap = {
    #   url = "github:ggandor/leap.nvim";
    #   flake = false;
    # };
    flash-nvim = {
      url = "github:folke/flash.nvim";
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
      url = "github:NeogitOrg/neogit";
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
      # bracket mappings
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
    nvim-lastplace = {
      url = "github:ethanholz/nvim-lastplace";
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
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
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
      url = "git+https://github.com/j-hui/fidget.nvim.git?ref=legacy";
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
    cmp-tmux = {
      url = "github:andersevenrud/cmp-tmux";
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
    # cmp-omni = {
    #   url = "github:hrsh7th/cmp-omni";
    #   flake = false;
    # };
    cmp-luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    cmp-luasnip-choice = {
      url = "github:L3MON4D3/cmp-luasnip-choice";
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
      # vscode-style completion pictograms
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    nvim-code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };
    cmp-dap = {
      url = "github:rcarriga/cmp-dap";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      # url = "/home/mrcjk/git/github/forks/nvim/nvim-treesitter-fork/";
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
    wildfire-nvim = {
      url = "github:sustech-data/wildfire.nvim";
      flake = false;
    };
    rainbow-delimiters-nvim = {
      url = "github:hiphish/rainbow-delimiters.nvim";
      flake = false;
    };
    vim-matchup = {
      # tree-sitter powered % motions
      url = "github:andymass/vim-matchup";
      flake = false;
    };
    iswap-nvim = {
      # url = "github:mizlan/iswap.nvim";
      url = "github:mrcjkb/iswap.nvim/haskell-nix";
      # url = "/home/mrcjk/git/github/forks/iswap.nvim";
      flake = false;
    };
    nvim-lint = {
      url = "github:mfussenegger/nvim-lint";
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
    mini-files = {
      url = "github:echasnovski/mini.files";
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
    promise-async = {
      # Dependency of nvim-ufo
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
      # Prevent nested neovim instances
      url = "github:samjwill/nvim-unception";
      flake = false;
    };
    tmux-nvim = {
      url = "github:aserowy/tmux.nvim";
      flake = false;
    };
    hardtime-nvim = {
      url = "github:m4xshen/hardtime.nvim";
      flake = false;
    };
    term-edit-nvim = {
      url = "github:chomosuke/term-edit.nvim";
      flake = false;
    };
    other-nvim = {
      url = "github:rgroli/other.nvim";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    neorocks,
    flake-utils,
    pre-commit-hooks,
    ...
  }: let
    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];

    plugin-overlay = import ./nix/plugin-overlay.nix {inherit inputs;};
    neovim-overlay = import ./nix/neovim-overlay.nix;
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          neorocks.overlays.default
          plugin-overlay
          neovim-overlay
          inputs.haskell-tools.overlays.default
          inputs.haskell-snippets.overlays.default
          inputs.neotest-haskell.overlays.default
          inputs.telescope-manix.overlays.default
        ];
      };
      shell = pkgs.mkShell {
        name = "nvim-devShell";
        buildInputs = with pre-commit-hooks.packages.${system}; [
          lua-language-server
          alejandra
          stylua
          luacheck
        ];
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
        default = nvim;
        nvim = pkgs.nvim-pkg;
        nvim-dev = pkgs.nvim-dev;
      };
      devShells = {
        default = shell;
      };
      checks = {
        inherit pre-commit-check;
      };
    })
    // {
      overlays.default = neovim-overlay;
    };
}
