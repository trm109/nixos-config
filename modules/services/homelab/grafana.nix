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
      default = "${config.networking.hostName}";
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
            domain = "optiplex";
            root_url = "http://optiplex/grafana/";
            serve_from_sub_path = true;
          };
        };
      };

      nginx.virtualHosts."optiplex" = {
        #enable = true;
        #ssl = true;
        #addSSL = true;
        #enable = lib.mkDefault true;
        #forceSSL = lib.mkDefault true;
        locations."/grafana/" = {
          proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          #proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
          #proxyPass = with config.services.grafana.settings.server; "${protocol}://${http_addr}:${http_port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
          #extraConfig = ''
          #  proxy_buffering off;
          #  proxy_cache off;
          #'';
        };
      };
    };
    # if external
    networking.firewall = {
      allowedTCPPorts = [ config.services.grafana.settings.server.http_port ];
      allowedUDPPorts = [ config.services.grafana.settings.server.http_port ];
    };
  };
}
