{
  lib,
  config,
  pkgs,
  hostType,
  users,
  ...
}:
let
  cfg = config.modules.services.razer;
in
{
  options.modules.services.razer = {
    enable = lib.mkOption {
      default = hostType == "desktop" || false;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.openrazer = {
      enable = true;
      inherit users;
      batteryNotifier.enable = true;
    };
    environment.systemPackages = with pkgs; [
      polychromatic
    ];
  };
}
