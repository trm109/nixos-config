{
  lib,
  config,
  ...
}: let
  cfg = config.modules.hardware.battery;
in {
  options.modules.hardware.battery = {
    enable = lib.mkEnableOption "Enable Battery Management Support";
  };

  config = lib.mkIf cfg.enable {
    # Battery management support
    services.upower = {
      enable = true;
      noPollBatteries = true;
    };
  };
}
