{
  description = "XDG config for nix home-manager";

  outputs = {self, ...}:
  {
    nixosModule = { pkgs, defaultUser, ... }: {

      home-manager.users."${defaultUser}" = {
       xdg.configFile."nvim" = {
          source = ./.;
          recursive = true;
        };   
      };

      nixpkgs = {
        overlays = [
          (self: super: {
             neovim = pkgs.unstable.neovim.override {
               viAlias = true;
               vimAlias = true;
             };
           })
        ];
      };

      environment = with pkgs; {
        systemPackages = [
          neovim
          unstable.neovim-remote
          unstable.tree-sitter
          unstable.sqlite
          (unstable.lua.withPackages (luapkgs: with luapkgs; [
                                      luacheck
                                      plenary-nvim
                                      luacov
          ]))
          unstable.haskellPackages.hoogle
          unstable.haskellPackages.hlint
          unstable.haskell-language-server
          unstable.haskellPackages.haskell-debug-adapter
          unstable.stylish-haskell
          unstable.rnix-lsp # Nix language server
          unstable.rust-analyzer
          unstable.sumneko-lua-language-server
          unstable.nodePackages.vim-language-server
          unstable.nodePackages.yaml-language-server
          unstable.nodePackages.dockerfile-language-server-nodejs
          unstable.glow # Render markdown on the command-line
          unstable.bat # cat with syntax highlighting
          unstable.ueberzug # Display images in terminal
          unstable.feh # Fast and light image viewer
          unstable.fzf # Fuzzy search
          unstable.xclip # Required so that neovim compiles with clipboard support
          unstable.ripgrep # Fast (Rust) re-implementation of grep
          unstable.fd # Fast alternative to find
          unstable.jdt-language-server
          unstable.nodePackages.yarn # Required by markdown-preview vim plugin
          python-language-server
          unstable.nodePackages.pyright
        ];
        sessionVariables = rec {
          LIBSQLITE_CLIB_PATH = "${unstable.sqlite.out}/lib/libsqlite3.so";
          LIBSQLITE = LIBSQLITE_CLIB_PATH; # Expected by sqlite plugin
        };
      };
    };
  };
}
