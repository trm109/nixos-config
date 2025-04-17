{ lib, config, ... }:
let
  cfg = config.modules.services.homelab.home-assistant;
in
{
  options.modules.services.homelab.home-assistant = {
    enable = lib.mkOption {
      default = false;
      description = "Enable Home Assistant";
    };
  };
  config = lib.mkIf cfg.enable {
    services.home-assistant = {
      enable = true;
      openFirewall = true;
      config = {
        homeassistant = {
          name = "homeassistant";
          longitude = 41.5;
          latitude = -81.6;
          temperature_unit = "F";
          time_zone = "America/New_York";
          unit_system = "us_customary";
        };
      };
    };
  };
}
