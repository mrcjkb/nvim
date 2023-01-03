{
  description = "XDG config for nix home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    neovim-nightly-overlay,
    pre-commit-hooks,
    ...
  }: let
    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    perSystem = nixpkgs.lib.genAttrs supportedSystems;
    pkgsFor = system: import nixpkgs {inherit system;};
    pre-commit-check-for = system:
      pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
        };
      };
    shellFor = system: let
      pkgs = pkgsFor system;
      pre-commit-check = pre-commit-check-for system;
    in
      pkgs.mkShell {
        name = "nixfiles-devShell";
        inherit (pre-commit-check) shellHook;
        buildInputs = with pkgs; [
          alejandra
        ];
      };
  in {
    nixosModule = {
      pkgs,
      defaultUser,
      ...
    }: {
      home-manager.users."${defaultUser}" = {
        xdg.configFile."nvim" = {
          source = ./.;
          recursive = true;
        };
      };

      nixpkgs = {
        overlays = [
          neovim-nightly-overlay.overlay
        ];
      };

      programs.fish.shellAliases = {
        nv = "neovide";
        luamake = "{$XDG_CACHE_HOME}/nvim/nlua/sumneko_lua/lua-language-server/3rd/luamake/luamake";
      };

      environment = with pkgs; let
        sumneko-lsp = unstable.sumneko-lua-language-server;
      in {
        systemPackages = [
          # unstable.neovim
          neovim-nightly
          unstable.neovide
          unstable.tree-sitter
          unstable.haskellPackages.hoogle
          unstable.haskellPackages.hlint
          unstable.haskell-language-server
          unstable.haskellPackages.haskell-debug-adapter
          unstable.haskellPackages.ghci-dap
          unstable.haskellPackages.haskell-dap
          unstable.haskellPackages.fast-tags # Fast tag generation
          unstable.haskellPackages.implicit-hie
          unstable.stylish-haskell
          unstable.nil # Nix language server
          unstable.rust-analyzer
          unstable.ninja # Small build system with a focus on speed (used to build sumneko-lua-language-server for nlua.nvim)
          unstable.sumneko-lua-language-server
          unstable.nodePackages.vim-language-server
          unstable.nodePackages.yaml-language-server
          unstable.nodePackages.dockerfile-language-server-nodejs
          unstable.nodePackages.vscode-json-languageserver-bin
          unstable.glow # Render markdown on the command-line
          unstable.bat # cat with syntax highlighting
          unstable.ueberzug # Display images in terminal
          unstable.feh # Fast and light image viewer
          unstable.fzf # Fuzzy search
          unstable.xclip # Required so that neovim compiles with clipboard support
          unstable.ripgrep # Fast (Rust) re-implementation of grep
          unstable.silver-searcher # Ag
          unstable.fd # Fast alternative to find
          unstable.deno # Used by peek.nvim for Markdown preview
          unstable.webkitgtk_4_1 # Dependency of deno, used by peek.nvim for Markdown preview
          unstable.jdt-language-server
          unstable.nodePackages.yarn # Required by markdown-preview vim plugin
          python-language-server
          (unstable.python3.withPackages (ps: with ps; [pynvim]))
          unstable.nodePackages.pyright
          unstable.stylua
        ];
        sessionVariables = rec {
          LIBSQLITE_CLIB_PATH = "${unstable.sqlite.out}/lib/libsqlite3.so";
          LIBSQLITE = LIBSQLITE_CLIB_PATH; # Expected by sqlite plugin
          SUMNEKO_BIN_PATH = "${sumneko-lsp}/bin/lua-language-server"; # Passed to nlua
          SUMNEKO_MAIN_PATH = "${sumneko-lsp}/share/lua-language-server/main.lua"; # Passed to nlua
        };
      };
    };

    devShells = perSystem (system: {
      default = shellFor system;
    });

    checks = perSystem (system: {
      formatting = pre-commit-check-for system;
    });
  };
}
