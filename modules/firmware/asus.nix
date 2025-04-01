{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.firmware.asus;
in
{
  options.modules.firmware.asus = {
    enable = lib.mkOption {
      default = false;
      description = "Enable ASUS hardware support";
    };
  };
  config = lib.mkIf cfg.enable {
    # Enable supergfxd
    services.supergfxd.enable = true;

    # Enable asusd
    services = {
      asusd = {
        enable = true;
        enableUserService = true;
      };
    };
  };
}
