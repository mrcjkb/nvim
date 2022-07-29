{
  description = "XDG config for nix home-manager";

  outputs = {self, ...}:
  {
    nixosModule = { defaultUser, ... }: {
      home-manager = {
       xdg.configFile."nvim" = {
          source = ./.;
          recursive = true;
        };   
      };
    };
  };
}
