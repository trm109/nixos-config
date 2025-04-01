# Things that a human would run
{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.applications;
in
{
  imports = [
    ./desktop
    ./graphical
    ./terminal
  ];
  options.modules.applications = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the applications module";
    };
  };
  config = lib.mkIf (!cfg.enable) {
    modules.applications = {
      graphical.enable = false;
      terminal.enable = false;
    };
  };
}
