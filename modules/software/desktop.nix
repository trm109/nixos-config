{ inputs, pkgs, ... }:
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
        nativeBuildInputs = old.nativeBuildInputs ++ [
          pkgs.unstable.pkg-config
          pkgs.unstable.meson
          pkgs.unstable.ninja
          pkgs.unstable.nodePackages.typescript
          pkgs.unstable.wrapGAppsHook
          pkgs.unstable.gobject-introspection
        ];
        buildInputs = old.buildInputs ++ [
          pkgs.unstable.gjs
          pkgs.unstable.gtk3
          pkgs.unstable.libpulseaudio
          pkgs.unstable.upower
          pkgs.unstable.gnome.gnome-bluetooth
          pkgs.unstable.gtk-layer-shell
          pkgs.unstable.glib-networking
          pkgs.unstable.networkmanager
          pkgs.unstable.libdbusmenu-gtk3
          pkgs.unstable.gvfs
          pkgs.unstable.libsoup_3
          pkgs.unstable.libnotify
          pkgs.unstable.pam
          pkgs.unstable.accountsservice
        ];
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
    helvum
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
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
}
