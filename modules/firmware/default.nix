{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.firmware;
in
{
  imports = [
    ./cpu
    ./gpu
    ./input
    ./asus.nix
  ];
  options.modules.firmware = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the firmware module";
    };
  };
  config = lib.mkIf cfg.enable {
    hardware.enableRedistributableFirmware = true;
    services.fwupd.enable = true;
    #modules.firmware = {
    #  cpu.enable = false;
    #  gpu.enable = false;
    #  input.enable = false;
    #  asus.enable = false;
    #};
  };
}
