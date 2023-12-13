# cups.nix
{
  # Enable Printing
  services.printing.enable = true;

  # Enable autodiscovery of printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Add printers.
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
}

