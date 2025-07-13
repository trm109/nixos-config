# Wayland specific settings, but not DE specific settings.
{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.applications.desktop.wayland;
in
{
  imports = [
    ./hyprland.nix
  ];

  options.modules.applications.desktop.wayland = {
    enable = lib.mkOption {
      # if hyprland (or other wayland DEs) are enabled, else false
      default = cfg.hyprland.enable || false;
      description = "Enable the Wayland desktop module";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      libinput = {
        enable = true;
      };
    };
  };
}
