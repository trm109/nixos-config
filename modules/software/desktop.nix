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
    #dunst
    #eww
    #stable.waybar
    #mako # Notifications
    fuzzel # App launcher
    lxqt.lxqt-policykit # Polkit
    pavucontrol # For audio control
    wl-clipboard # for clipboard
    libsForQt5.qt5ct # For Qt5 config tool
    grim # For screnshots
    slurp # For screenshots
    libnotify # Notify lib
    unstable.hyprlock # For screenlocking
    networkmanagerapplet # Applet for networkmanager
    hyprpaper # Wallpapers
    helvum # For piping audio
    brightnessctl # For changing brightness
    gtk3 # For gtk apps
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default # Cursor
    hyprpanel # Panel and notif manager
    upower # TODO this is a temporary fix for the battery icon
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
