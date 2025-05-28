{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.firmware.input.qmk;
in
{
  options.modules.firmware.input.qmk = {
    enable = lib.mkOption {
      default = config.modules.applications.graphical.enable || false;
      description = "Enable QMK firmware support";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      udev = {
        packages = [ pkgs.via ];
        # Keychron K10 Pro
        #Vid: 0x3434
        #Pid: 0x02A0
        extraRules = ''
          SUBSYSTEMS=="usb", ATTR{idVendor}=="3434", ATTR{idProduct}=="02A0", TAG+="uaccess"
        '';
      };
    };
    environment.systemPackages = with pkgs; [
      via
    ];
  };
}
