{ config, lib, ... }:
let
  cfg = config.modules.services.homelab.grafana;
in
{
  options.modules.services.homelab.grafana = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Grafana service";
    };
    grafanaUrl = lib.mkOption {
      type = lib.types.str;
      default = "http://localhost:3000";
      description = "URL to access Grafana";
    };
  };
  config = lib.mkIf cfg.enable {
    services.grafana = {
      enable = true;
      settings = {
        server = {
          # Listening Address
          http_addr = "127.0.0.1";
          # and Port
          http_port = 3000;
          # Grafana needs to know on which domain and URL it's running
          domain = "your.domain";
          root_url = "https://your.domain/grafana/"; # Not needed if it is `https://your.domain/`
          serve_from_sub_path = true;
        };
      };
    };
  };
}
