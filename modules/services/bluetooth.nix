{
  lib,
  pkgs,
  config,
  hostType,
  ...
}:
let
  cfg = config.modules.services.bluetooth;
in
{
  options.modules.services.bluetooth = {
    enable = lib.mkOption {
      default = hostType == "desktop" || false;
      description = "Enable the bluetooth module";
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      extraModprobeConfig = ''
        options bluetooth disable_ertm=Y
      '';
      initrd.kernelModules = [
        "joydev" # joystick support
        "usbhid"
      ];
    };
    environment.systemPackages = with pkgs; [
      bluetui # bluetooth manager TUI
    ];
    hardware = {
      xpadneo.enable = true; # Xbox Controller - Bluetooth
      xone.enable = true; # Xbox Controller - USB & wireless dongle
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Experimental = true;
            Privacy = "device";
            JustWorksRepairing = "always";
            class = "0x000100";
            FastConnectable = true;
            ClassicBondedOnly = false;
            #LEAutoSecurity = false;
            UserspaceHID = true;
          };
        };
      };
    };
    services.blueman.enable = true;
  };
}
