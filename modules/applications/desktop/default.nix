# Settings specific to devices with a desktop environment
{
  hostType,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.applications.desktop;
in
{
  imports = [
    ./wayland
    ./x11
  ];

  options.modules.applications.desktop = {
    enable = lib.mkOption {
      # if wayland or x11 is enabled, enable desktop by default.
      # if hostType is desktop, enable desktop by default.
      # else false
      default = cfg.wayland.enable || cfg.x11.enable || hostType == "desktop";
      description = "Enable the desktop applications module";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      # Display manager
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-user-session";
            user = "greeter";
          };
        };
      };
    };
  };
}
