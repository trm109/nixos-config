{ config, lib, ... }:
let
  hcfg = config.modules.services.homelab;
  cfg = config.modules.services.homelab.glance;
in
{
  options.modules.services.homelab.glance = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable glance";
    };
    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "${hcfg.domain}";
      description = "Subdomain for glance";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://docs.openstack.org/glance/latest/user/index.html
    services = {
      glance = {
        enable = true;
      };
      nginx.virtualHosts.${cfg.subdomain} = {
        enableACME = hcfg.useHttps;
        addSSL = hcfg.useHttps && !hcfg.forceHttps;
        onlySSL = hcfg.forceHttps;
        locations."/" = lib.mkForce {
          proxyPass = with config.services.glance.settings.server; "http://${host}:${toString port}";
          proxyWebsockets = true;
        };
      };
    };
  };
}
