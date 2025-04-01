{
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.applications.desktop.x11.i3;
in
{
  options.modules.applications.desktop.x11.i3 = {
    enable = lib.mkOption {
      default = false;
      description = "Enable the i3 desktop applications module";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      i3-gaps
      i3status
      i3lock
      rofi
    ];
  };
}
