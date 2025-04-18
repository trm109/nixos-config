{ lib, config, ... }:
let
  cfg = config.modules.services.homelab.home-assistant;
in
{
  options.modules.services.homelab.home-assistant = {
    enable = lib.mkOption {
      default = config.modules.services.homelab.enable || false;
      description = "Enable Home Assistant";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Domain for Home Assistant";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      home-assistant = {
        enable = true;
        #openFirewall = true;
        config = {
          homeassistant = {
            name = "homeassistant";
            longitude = 41.5;
            latitude = -81.6;
            temperature_unit = "F";
            time_zone = "America/New_York";
            unit_system = "us_customary";
            external_url = "https://${cfg.domain}/home";
          };
          http = {
            server_host = "127.0.0.1";
            #use_x_forwarded_for = true;
            trusted_proxies = [
              "127.0.0.1"
            ];
            #cors_allowed_origins = [
            #  "http://${cfg.domain}"
            #  "https://${cfg.domain}"
            #];
          };
        };
      };
      nginx.virtualHosts.${cfg.domain}.locations."/home/" = {
        proxyPass =
          with config.services.home-assistant.config.http;
          "http://127.0.0.1:${toString server_port}/lovelace/default_view";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_redirect http:// https://;
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $connection_upgrade;
        '';
        #proxyWebsockets = true;
        #recommendedProxySettings = true;
      };
    };
  };
}
