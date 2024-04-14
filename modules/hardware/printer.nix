{ lib, ... }:
{
# Printer
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
    ensureDefaultPrinter = "UTech_Printer";
  };
  programs.system-config-printer.enable = true;
  #systemd.targets.ensure-printers.wantedBy = pkgs.lib.mkForce [];
  systemd.services.ensure-printers.wantedBy = lib.mkForce [];
}
