{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    brave
    (prismlauncher.override { jdks = [ jdk8 jdk17 ]; })
    vesktop
    spotify
    unstable.zoom-us
    stremio
    xfce.thunar
    libreoffice
    snapshot
    darktable
    firefox
  ];
  #programs.ags = {
  #  enable = true;
  #  package = ags.packages."x86_64-linux".default;
  #};

  services.flatpak = {
    enable = true;
    update.onActivation = true;
    packages = [
      { flatpakref="https://sober.vinegarhq.org/sober.flatpakref"; sha256="1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l"; }
    ];
  };
  #Thunar
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  #programs.firefox = {
  #  enable = true;
  #  package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {});
  #};
  environment.sessionVariables = {
    #MOZ_USE_XINPUT2 = "1";
    #MOZ_ENABLE_WAYLAND = "1";
    XDG_DATA_HOME   = "$HOME/var/lib";
    XDG_CACHE_HOME  = "$HOME/var/cache";
    XDG_VIDEOS_DIR  = "$HOME/Videos/";
  };
  # Flox
  nix.settings.trusted-substituters = [ "https://cache.flox.dev" ];
  nix.settings.trusted-public-keys = [ "flox-cache-public-1:7F4OyH7ZCnFhcze3fJdfyXYLQw/aV7GEed86nQ7IsOs=" ];
}
