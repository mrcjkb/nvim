{self}: final: prev: let
  lib = final.pkgs.lib;
  nvim-module = lib.evalModules {
    modules = [
      self.outputs.nixosModules.default
    ];
    check = false;
  };
  cfg = nvim-module.config.programs.nvim;
in {
  nvim-pkg = cfg.package;
}
