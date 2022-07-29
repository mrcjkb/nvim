{
  description = "XDG config for nix home-manager";

  outputs = {self, ...}:
  {
    nixosModule = { defaultUser, ... }: {
      home-manager.users."${defaultUser}" = {
       xdg.configFile."nvim" = {
          source = ./.;
          recursive = true;
        };   
      };
    };
  };
}
