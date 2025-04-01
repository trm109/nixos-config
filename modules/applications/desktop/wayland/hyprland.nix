# Hyprland specific settings
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.applications.desktop.wayland.hyprland;
in
{
  options.modules.applications.desktop.wayland.hyprland = {
    enable = lib.mkOption {
      default = false;
      description = "Enable the Hyprland desktop module";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fuzzel # App Launcher
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default # Cursor

      hyprpaper # Wallpaper
      hyprpanel # status bar
      hyprshot # Screenshots
      hyprlock # Lock screen
      hyprpolkitagent # Auth prompt for certain apps.

      cava # audio visualizer

      upower # TODO make laptop specific
    ];

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
      package = pkgs.hyprland;
      #portalPackage = pkgs.stable.xdg-desktop-portal-hyprland;
    };

    #xdg = {
    #  portal = {
    #    enable = true;
    #    extraPortals = [
    #      pkgs.xdg-desktop-portal-gtk
    #    ];
    #  };
    #};
  };
}
