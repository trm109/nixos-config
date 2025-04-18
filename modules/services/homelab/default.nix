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
    ./glance.nix
    ./teslamate.nix
    ./tailscale.nix
    ./nginx.nix
  ];
  options.modules.services.homelab = {
    enable = lib.mkOption {
      default = false;
      description = "Enable the services module";
    };
  };
  config = lib.mkIf cfg.enable {
    modules.services.homelab = {
      grafana.enable = true;
      glance.enable = true;
      home-assistant.enable = true;
      teslamate.enable = true;
      tailscale.enable = true;
      nginx.enable = true;
    };

    #services = {
    #  avahi = {
    #    enable = true;
    #    nssmdns4 = true;
    #    publish = {
    #      enable = true;
    #      addresses = true;
    #    };
    #  };
    #};
    #networking.firewall.allowedTCPPorts = [
    #  80
    #  443
    #];

  };
  #config = lib.mkIf (!cfg.enable) {
  #  modules.services.homelab = {
  #    home-assistant.enable = false;
  #    grafana.enable = false;
  #    teslamate.enable = false;
  #  };
  #};
}
