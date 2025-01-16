{
  inputs,
  pkgs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };
  #services.desktopManager.plasma6.enable = true;
  # Display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
  #programs.ags = {
  #  enable = true;
  #  extraPackages = with pkgs; [
  #    gtksourceview
  #    webkitgtk
  #    accountsservice
  #  ];
  #};
  environment.systemPackages = with pkgs; [
    #(inputs.ags.packages."x86_64-linux".default.override = {})
    #ags
    dunst
    eww
    stable.waybar
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
