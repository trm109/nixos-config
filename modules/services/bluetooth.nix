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
        "xpad"
        "joydev"
        "usbhid"
      ];
    };
    environment.systemPackages = with pkgs; [
      bluetui # bluetooth manager TUI
    ];
    hardware.bluetooth = {
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
    services.blueman.enable = true;
  };
}
