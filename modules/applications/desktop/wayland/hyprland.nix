# Hyprland specific settings
{
  lib,
  pkgs,
  config,
  inputs,
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
      inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default # Cursor
      upower # TODO make laptop specific
    ];

    programs.hyprland = {
      enable = true;
      #portalPackage = pkgs.stable.xdg-desktop-portal-hyprland;
    };
  };
}
