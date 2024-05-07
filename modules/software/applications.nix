{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    chromium
    (prismlauncher.override { jdks = [ jdk8 jdk17 ]; })
    vesktop
    spotify
    unstable.zoom-us
    stremio
    xfce.thunar
    libreoffice
    snapshot
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

  environment.sessionVariables = {
    XDG_CONFIG_HOME = "$HOME/etc";
    XDG_DATA_HOME   = "$HOME/var/lib";
    XDG_CACHE_HOME  = "$HOME/var/cache";
    XDG_VIDEOS_DIR  = "$HOME/Videos/";
  };
  # Flox
  nix.settings.trusted-substituters = [ "https://cache.flox.dev" ];
  nix.settings.trusted-public-keys = [ "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=" ];
}
