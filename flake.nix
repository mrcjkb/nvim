{
  description = "XDG config for nix home-manager";

  outputs = {self, ...}:
  {
    nvimConfig = { defaultUser, ... }: {
      home-manager = {
       xdg.configFile."nvim" = {
          source = ./.;
          recursive = true;
        };   
      };
    };
  };
}
