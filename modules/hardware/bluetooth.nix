{ lib, config, hostType, ... }:
let
  cfg = config.modules.hardware.bluetooth;
in 
{
  options.modules.hardware.bluetooth = {
    enable = lib.mkEnableOption "Enables bluetooth support" // {
      default = if hostType == "desktop" then true
      	else if hostType == "server" then false
        else true;
    };
  };
  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
        };
      };

    };
    services.blueman.enable = true;
  };
}
