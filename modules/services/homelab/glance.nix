{ config, lib, ... }:
let
  cfg = config.modules.services.homelab.glance;
in
{
  options.modules.services.homelab.glance = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable glance";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Domain for glance";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://docs.openstack.org/glance/latest/user/index.html
    services = {
      glance = {
        enable = true;
      };
      nginx.virtualHosts.${cfg.domain}.locations."/" = lib.mkForce {
        proxyPass = with config.services.glance.settings.server; "http://${host}:${toString port}";
        proxyWebsockets = true;
      };
    };
  };
}
