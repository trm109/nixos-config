{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.services.homelab;
in
{
  imports = [
    ./home-assistant.nix
    ./grafana.nix
    ./teslamate.nix
  ];
  options.modules.services = {
    enable = lib.mkOption {
      default = false;
      description = "Enable the services module";
    };
  };
  config = lib.mkIf (!cfg.enable) {
    modules.services = {
    };
  };
}
