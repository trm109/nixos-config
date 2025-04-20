{ config, lib, ... }:
let
  hcfg = config.modules.services.homelab;
  cfg = config.modules.services.homelab.grafana;
in
{
  options.modules.services.homelab.grafana = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.services.homelab.enable || false;
      description = "Enable Grafana service";
    };
    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "grafana.${hcfg.domain}";
      description = "Subdomain for Grafana service";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 3012;
      description = "Port for Grafana service";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      grafana = {
        enable = true;
        settings = {
          analytics = {
            reporting_enabled = false;
          };
          server = {
            #DEBUG
            router_logging = true;
            http_addr = "127.0.0.1";
            http_port = cfg.port;
            domain = cfg.subdomain;
            enforce_domain = true;
          };
        };
      };

      nginx.virtualHosts."${cfg.subdomain}" = {
        enableACME = hcfg.useHttps;
        addSSL = hcfg.useHttps && !hcfg.forceHttps;
        onlySSL = hcfg.forceHttps;
        locations."/" = {
          proxyPass =
            with config.services.grafana.settings.server;
            "${protocol}://${http_addr}:${toString http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          #extraConfig = ''
          #  proxy_buffering off;
          #  proxy_cache off;
          #'';
        };
      };

    };
  };
}
