{ config, lib, ... }:
let
  cfg = config.modules.services.homelab.grafana;
in
{
  options.modules.services.homelab.grafana = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.services.homelab.enable || false;
      description = "Enable Grafana service";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Domain for Grafana service";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 3000;
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
            #enforce_domain = true;
            http_addr = "127.0.0.1";
            http_port = cfg.port;
            domain = cfg.domain;
            root_url = "http://${cfg.domain}/grafana/";
            serve_from_sub_path = true;
          };
        };
      };

      nginx.virtualHosts.${cfg.domain}.locations."/grafana/" = {
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
}
