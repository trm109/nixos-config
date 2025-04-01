{
  hw,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.firmware.cpu.amd;
in
{
  options.modules.firmware.cpu.amd = {
    enable = lib.mkOption {
      default = hw.cpu.vendor == "amd" || false;
      description = "Enable AMD CPU specific firmware settings";
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO add more stuff
    hardware.cpu.amd = {
      updateMicrocode = true;
    };
  };
}
