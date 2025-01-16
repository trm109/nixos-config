{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty # Terminal
    brave # Chromium Browser
    vesktop # Discord, customized for linux
    spotify # Music streaming (Look for more performant alternatives)
    #zoom-us # Just use the web version
    # TODO fix for wayland-nvidia
    firefox # Web browser
    stremio # Video player + Torrent streaming
    xfce.thunar # File manager
    libreoffice # Office suite
    snapshot # Simple camera
    darktable # Photo editing
    rclone # File sync
    #blender-hip
    #insomnia # API Testing, should really use nix-shell, nix develop, or devenv
  ];

  #programs.ags = {
  #  enable = true;
  #  package = ags.packages."x86_64-linux".default;
  #};

  #Thunar
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  # TODO look over more options
  environment.sessionVariables = {
    #MOZ_USE_XINPUT2 = "1";
    #MOZ_ENABLE_WAYLAND = "1";
    XDG_DATA_HOME   = "$HOME/var/lib";
    XDG_CACHE_HOME  = "$HOME/var/cache";
    XDG_VIDEOS_DIR  = "$HOME/Videos/";
  };
  # TODO figure out if this is necessary
  # Flox 
  nix.settings.trusted-substituters = [ "https://cache.flox.dev" ];
  nix.settings.trusted-public-keys = [ "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=" ];
}
