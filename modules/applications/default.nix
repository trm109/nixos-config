# Things that a human would run
{ lib, ... }:
let
  cfg = config.modules.applications;
in
{
  imports = [
    ./graphical.nix
    ./terminal.nix
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
