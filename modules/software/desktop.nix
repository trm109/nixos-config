{ pkgs, ... }:
{
  programs.hyprland.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };
  environment.systemPackages = with pkgs; [
    waybar
    fuzzel
    lxqt.lxqt-policykit
    pavucontrol
    wl-clipboard
    libsForQt5.qt5ct
  ];
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
}
