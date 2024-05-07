{ pkgs, ... }:
let
  #custom-ags = pkgs.buildNpmPackage {
  #  name = "ags";
  #  src = pkgs.fetchFromGitHub {
  #    owner = "Aylur";
  #    repo = "ags";
  #    npmDepsHash = "sha256-ucWdADdMqAdLXQYKGOXHNRNM9bhjKX4vkMcQ8q/GZ20=";
  #    #rev = "33bcaf34d5277031ecb97047fb8ddd44abd8d80e";
  #    #sha256 = "01gm4abr6df6v2fzmj20kjw64w5lmgp1bil1kdiy53549fl1adig";
  #    #hash = "sha256-LzYVqEukjOJjm4HGFe6rtHBiuJxAyPqd2MY1k5ci9QU=";
  #    hash = lib.fakeSha256;
  #    fetchSubmodules = true;
  #  };
  #  nativeBuildInputs = with pkgs; nope, just `/etc/nixos/modules/software/desktop.ni[
  #    meson
  #    ninja
  #    pkg-config
  #    gjs
  #    gobject-introspection
  #    typescript
  #    wrapGAppsHook
  #  ];
  #  buildInputs = with pkgs; [
  #    gjs
  #    gtk3
  #    libpulseaudio
  #    upower
  #    gnome.gnome-bluetooth
  #    gtk-layer-shell
  #    glib-networking
  #    networkmanager
  #    libdbusmenu-gtk3
  #    gvfs
  #    libsoup_3
  #    libnotify
  #    pam
  #  ];
  #};

in 
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  nixpkgs.overlays = [
    (final: prev:
    {
      unstable.ags = prev.unstable.ags.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [ pkgs.libdbusmenu-gtk3 ];
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    #(inputs.ags.packages."x86_64-linux".default.override = {})
    unstable.ags
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
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
}
