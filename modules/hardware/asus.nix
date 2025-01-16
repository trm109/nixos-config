{
  lib,
  config,
  ...
}: let
  cfg = config.modules.hardware.asus;
in {
  options.modules.hardware.asus = {
    enable = lib.mkEnableOption "Enables Asus Specific Tweaks";
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
