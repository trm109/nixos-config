{ lib, config, hostType, ... }:
let
  cfg = config.modules.hardware.printers;
in
{
  options.modules.hardware.printers = {
    enable = lib.mkEnableOption "Enable printer support" // {
      default = if hostType == "desktop" then true 
        else if hostType == "server" then false
        else true;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      printing.enable = true;
      avahi = {
        enable = true;
        nssmdns = true;
        openFirewall = true;
      };
    };
    #UTech Printer
    hardware.printers = {
      ensurePrinters = [
        {
          name = "UTech_Printer";
          location = "CARE_Center";
          deviceUri = "lpd://129.22.99.235/queue";
          model = "drv:///sample.drv/generic.ppd";
        }
      ];
    };
    #systemd.targets.ensure-printers.wantedBy = pkgs.lib.mkForce [];
    systemd.services.ensure-printers.wantedBy = lib.mkForce [];
  };
}
