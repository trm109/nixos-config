# Things that a human would run
{
  hostType,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.applications;
in
{
  imports = [
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
      graphical.enable = hostType == "desktop" || false;
      terminal.enable = false;
    };
  };
}
