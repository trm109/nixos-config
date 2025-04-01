# Wayland specific settings, but not DE specific settings.
{
  lib,
  pkgs,
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
    environment = {
      # TODO look over more options
      sessionVariables = {
        #MOZ_USE_XINPUT2 = "1";
        MOZ_ENABLE_WAYLAND = "1";
        XDG_DATA_HOME = "$HOME/var/lib";
        XDG_CACHE_HOME = "$HOME/var/cache";
        XDG_VIDEOS_DIR = "$HOME/Videos/";
      };
      systemPackages = with pkgs; [
        wl-clipboard # Wayland clipboard manager
        waypipe # Wayland remote desktop
        weston # Wayland compositor
      ];
    };
    services = {
      libinput = {
        enable = true;
        #touchpad = {};
        #mouse = {};
      };
    };
  };
}
