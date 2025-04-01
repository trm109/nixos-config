{
  inputs,
  pkgs,
  system,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
    package = pkgs.hyprland;
    #portalPackage = pkgs.stable.xdg-desktop-portal-hyprland;
  };
  #services.desktopManager.plasma6.enable = true;
  # Display manager
  services = {
    libinput.enable = true;
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
  environment.systemPackages = with pkgs; [
    fuzzel # App launcher
    pavucontrol # For audio control
    wl-clipboard # for clipboard
    libsForQt5.qt5ct # For Qt5 config tool
    libnotify # Notify lib
    networkmanagerapplet # Applet for networkmanager
    helvum # For piping audio
    brightnessctl # For changing brightness
    gtk3 # For gtk apps
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default # Cursor

    hyprpaper # Wallpapers
    hyprpanel # Panel and notif manager
    hyprshot
    hyprlock
    hyprpolkitagent

    upower # TODO this is a temporary fix for the battery icon
    cava # Cava for Hyprpanel
  ];

  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
    mime = {
      enable = true;
    };
  };
}
