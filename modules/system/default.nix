{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.system;
in
{
  imports = [
    ./kernel.nix
    ./locale.nix
    ./nix
  ];
  options.modules.system = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the system module";
    };
  };

  config = lib.mkIf (!cfg.enable) {
    modules.system = {
      kernel.enable = false;
      locale.enable = false;
      nix.enable = false;
    };
  };
}
