{ lib, config, ... }:
let
  hcfg = config.modules.services.homelab;
  cfg = config.modules.services.homelab.home-assistant;
in
{
  options.modules.services.homelab.home-assistant = {
    enable = lib.mkOption {
      default = config.modules.services.homelab.enable || false;
      description = "Enable Home Assistant";
    };
    subdomain = lib.mkOption {
      type = lib.types.str;
      default = "home.${hcfg.domain}";
      description = "Subdomain for Home Assistant";
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
          };
          http = {
            server_host = "127.0.0.1";
            use_x_forwarded_for = true;
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
      # https://github.com/home-assistant/architecture/issues/156#issuecomment-478183627
      nginx.virtualHosts."${cfg.subdomain}" = {
        enableACME = hcfg.useHttps;
        addSSL = hcfg.useHttps && !hcfg.forceHttps;
        onlySSL = hcfg.forceHttps;
        locations."/" = {
          proxyPass =
            with config.services.home-assistant.config.http;
            "http://127.0.0.1:${toString server_port}/lovelace/default_view";
          proxyWebsockets = true;
          #recommendedProxySettings = true;
        };
      };
    };
  };
}
