{
  description = "Neovim config";

  nixConfig = {
    extra-substituters = [
      "https://mrcjkb.cachix.org"
      "https://nix-community.cachix.org"
      "https://nomad.cachix.org"
    ];
    extra-trusted-public-keys = [
      "mrcjkb.cachix.org-1:KhpstvH5GfsuEFOSyGjSTjng8oDecEds7rbrI96tjA4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs"
      "nomad.cachix.org-1:jQ4al6yxQyvUBB7YJVJbMbc9rASokqamqvPhBUrVjww="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neorocks = {
      url = "github:nvim-neorocks/neorocks";
    };
    spell-de-dictionary = {
      url = "https://www.mirrorservice.org/pub/vim/runtime/spell/de.utf-8.spl";
      flake = false;
    };
    spell-de-suggestions = {
      url = "https://www.mirrorservice.org/pub/vim/runtime/spell/de.utf-8.sug";
      flake = false;
    };
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";

    # Plugins
    haskell-tools = {
      url = "github:mrcjkb/haskell-tools.nvim";
      # url = "/home/mrcjk/.local/share/nvim/site/pack/dev/opt/haskell-tools.nvim";
    };
    neotest-haskell = {
      url = "github:mrcjkb/neotest-haskell";
    };
    rustaceanvim = {
      url = "github:mrcjkb/rustaceanvim";
    };
    lz-n = {
      url = "github:nvim-neorocks/lz.n";
      # url = "/home/mrcjk/git/github/mrcjkb/lz.n";
    };
    fff-nvim.url = "github:dmtrKovalenko/fff.nvim";
      # url = "/home/mrcjk/git/github/forks/nvimPackages/neotest/";
    crates-nvim = {
      url = "github:saecki/crates.nvim";
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
    vim-wordmotion = {
      # Vimscript
      url = "github:chaoren/vim-wordmotion";
      flake = false;
    };
    nvim-highlight-colors = {
      url = "github:brenoprata10/nvim-highlight-colors";
      flake = false;
    };
    flash-nvim = {
      url = "github:folke/flash.nvim";
      flake = false;
    };
    eyeliner-nvim = {
      url = "github:jinh0/eyeliner.nvim";
      flake = false;
    };
    gitlinker = {
      url = "github:linrongbin16/gitlinker.nvim";
      flake = false;
    };
    surround = {
      url = "github:kylechui/nvim-surround";
      flake = false;
    };
    substitute = {
      url = "github:gbprod/substitute.nvim";
      flake = false;
    };
    persistence = {
      url = "github:folke/persistence.nvim";
      flake = false;
    };
    nvim-lastplace.url = "github:mrcjkb/nvim-lastplace";
    comment = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };
    neotest = {
      # url = "github:nvim-neotest/neotest";
      url = "github:mrcjkb/neotest/mj/push-wssspnkwnzyu";
      # url = "/home/mrcjk/git/github/forks/nvimPackages/neotest/";
      flake = false;
    };
    nio = {
      url = "github:nvim-neotest/nvim-nio";
      flake = false;
    };
    neotest-java = {
      url = "github:rcasia/neotest-java";
      flake = false;
    };
    neotest-busted = {
      url = "gitlab:HiPhish/neotest-busted";
      flake = false;
    };
    schemastore-nvim = {
      url = "github:b0o/SchemaStore.nvim";
      flake = false;
    };
    jdtls = {
      # FIXME: Update setup in dotfiles
      url = "github:mfussenegger/nvim-jdtls";
      flake = false;
    };
    live-rename-nvim = {
      url = "github:saecki/live-rename.nvim";
      flake = false;
    };
    fidget = {
      url = "git+https://github.com/j-hui/fidget.nvim.git";
      flake = false;
    };
    illuminate = {
      url = "github:RRethy/vim-illuminate";
      flake = false;
    };
    actions-preview-nvim = {
      url = "github:aznhe21/actions-preview.nvim";
      flake = false;
    };
    treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects/main";
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
    rainbow-delimiters-nvim = {
      url = "github:hiphish/rainbow-delimiters.nvim";
      flake = false;
    };
    vim-matchup = {
      # tree-sitter powered % motions
      url = "github:andymass/vim-matchup";
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
    lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };
    oil-nvim = {
      url = "github:stevearc/oil.nvim";
      flake = false;
    };
    harpoon = {
      url = "github:ThePrimeagen/harpoon/harpoon2";
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
    quicker-nvim = {
      url = "github:stevearc/quicker.nvim";
      flake = false;
    };
    yanky = {
      url = "github:gbprod/yanky.nvim";
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
    term-edit-nvim = {
      url = "github:chomosuke/term-edit.nvim";
      flake = false;
    };
    other-nvim = {
      url = "github:rgroli/other.nvim";
      flake = false;
    };
    which-key-nvim = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };
    nomad.url = "github:nomad/nomad";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    neovim-nightly,
    neorocks,
    gen-luarc,
    flake-utils,
    git-hooks,
    ...
  }: let
    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    plugin-overlay = import ./nix/plugin-overlay.nix {inherit inputs;};
    neovim-overlay = import ./nix/neovim-overlay.nix {inherit inputs;};
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          neorocks.overlays.default
          neovim-nightly.overlays.default
          gen-luarc.overlays.default
          plugin-overlay
          neovim-overlay
        ];
      };
      shell = pkgs.mkShell {
        name = "nvim-devShell";
        buildInputs =
          self.checks.${system}.git-hooks-check.enabledPackages
          ++ (with pkgs; [
            lua-language-server
            # emmylua-ls
            nil
          ]);
        shellHook = ''
          ${self.checks.${system}.git-hooks-check.shellHook}
          ln -fs ${pkgs.luarc-json} .luarc.json
        '';
      };
      git-hooks-check = git-hooks.lib.${system}.run {
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
        nvim-profile = pkgs.nvim-profile;
        nightly = pkgs.neovim-nightly;
      };
      devShells = {
        default = shell;
      };
      checks = {
        inherit git-hooks-check;
      };
    })
    // {
      overlays.default = neovim-overlay;
    };
}
