{
  lib,
  pkgs,
  ...
}: {
  environment = {
    # TODO look over more options
    sessionVariables = {
      #MOZ_USE_XINPUT2 = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_DATA_HOME = "$HOME/var/lib";
      XDG_CACHE_HOME = "$HOME/var/cache";
      XDG_VIDEOS_DIR = "$HOME/Videos/";
    };
    systemPackages = with pkgs; [
      kitty # Terminal
      #brave # Chromium Browser
      webcord # Discord client
      #spotify # Music streaming (Look for more performant alternatives)
      #zoom-us # Just use the web version
      # TODO fix for wayland-nvidia
      unstable.firefox # Web browser
      stremio # Video player + Torrent streaming
      xfce.thunar # File manager
      stable.libreoffice # Office suite
      snapshot # Simple camera
      darktable # Photo editing
      rclone # File sync
      #blender-hip
      #insomnia # API Testing, should really use nix-shell, nix develop, or devenv
      cheese # simple camera
      mailspring # Email client
      vial # QMK keyboard stuff
      #((pkgs.callPackage ../../pkgs/exo.nix {}).override
      #  {rocmSupport = true;}) # Exo
      mpv
    ];
  };

  #Thunar
  programs = {
    thunar.enable = true;
    xfconf.enable = true;
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
  systemd.services = {
    gvfs.wantedBy = lib.mkForce [];
    tumbler.wantedBy = lib.mkForce [];
    ollama.wantedBy = lib.mkForce [];
    open-webui.wantedBy = lib.mkForce [];
  };
  services = {
    gvfs = {
      enable = true; # Mount, trash, and other functionalities
      #wantedBy = lib.mkForce [];
    };
    tumbler = {
      #wantedBy = lib.mkForce [];
      enable = true; # Thumbnail support for images
    };
    ollama = {
      #wantedBy = lib.mkForce [];
      enable = true;
      #package = pkgs.ollama-rocm;
      acceleration = "rocm";
      #loadModels = ["qwen2.5-coder:3b"];
      port = 11434;
    };
    open-webui = {
      enable = true;
    };
  };
}
