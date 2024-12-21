{ inputs, pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    #(inputs.ags.packages."x86_64-linux".default.override = {})
    #unstable.ags
    dunst
    eww
    waybar
    fuzzel
    lxqt.lxqt-policykit
    pavucontrol
    wl-clipboard
    libsForQt5.qt5ct
    grim
    slurp
    libnotify
    unstable.hyprlock
    networkmanagerapplet
    networkmanager-fortisslvpn
    networkmanager-openconnect
    openconnect
    openfortivpn
    hyprpaper
    helvum
    brightnessctl
    gtk3
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
  ];

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
    mime = {
      enable = true;
    };
  };
  services.libinput.enable = true;
}
