{
  lib,
  config,
  hw,
  ...
}:
let
  cfg = config.modules.services.battery;
in
{
  options.modules.services.battery = {
    enable = lib.mkOption {
      default = hw.formFactor == "laptop" || false;
      description = "Enable the battery management module";
    };
  };

  config = lib.mkIf cfg.enable {
    # Battery management support
    services.upower = {
      enable = true;
      noPollBatteries = true;
    };
  };
}
