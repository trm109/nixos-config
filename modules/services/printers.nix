{
  lib,
  config,
  hostType,
  ...
}:
let
  cfg = config.modules.services.printers;
in
{
  options.modules.services.printers = {
    enable = lib.mkOption {
      default = hostType == "desktop" || false;
      description = "Enable the printers module";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      printing.enable = true;
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
    #UTech Printer TODO make this asus-flow only
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
    systemd.services.ensure-printers.wantedBy = lib.mkForce [ ];
  };
}
