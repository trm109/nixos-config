{
  config,
  lib,
  ...
}:
let
  cfg = config.modules;
in
{
  imports = [
    ./applications
    ./firmware
    ./services
    ./system
  ];
  options.modules = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the modules module";
    };
  };
  config = lib.mkIf (!cfg.enable) {
    modules = {
      applications.enable = false;
      firmware.enable = false;
      services.enable = false;
      system.enable = false;
    };
  };
}
