{pkgs, ...}: {
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
      webcord # Discord client
      #spotify # Music streaming (Look for more performant alternatives)
      #zoom-us # Just use the web version
      librewolf # Web browser
      brave
      stremio # Video player + Torrent streaming
      xfce.thunar # File manager
      stable.libreoffice # Office suite
      snapshot # Simple camera
      darktable # Photo editing
      rclone # File sync
      blender-hip
      cheese # simple camera
      mailspring # Email client
      vial # QMK keyboard stuff
      mpv # Video player
      kdePackages.filelight # Disk usage analyzer
      bitwarden # Password manager
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
    #gvfs = {
    #  inherit wantedBy;
    #};
    #tumbler = {
    #  inherit wantedBy;
    #};
    ollama = {
      #inherit wantedBy;
      environment = {
        ROCR_VISIBLE_DEVICES = "0";
        HSA_OVERRIDE_GFX_VERSION = "11.0.0"; # Need to override my gfx version for some reason
      };
    };
    #open-webui = {
    #  inherit wantedBy;
    #};
  };
  services = {
    gvfs = {
      # Gnome Virtual File System
      # Allows applications to access files on local and remote file systems
      # Includes mounting of drives
      enable = true; # Mount, trash, and other functionalities
    };
    tumbler = {
      # Requests thumbnails for files
      enable = true;
    };
    ollama = {
      # Local LLM runner
      enable = true;
      package = pkgs.ollama-rocm;
      acceleration = "rocm";
      #loadModels = ["qwen2.5-coder:3b" "deepseek-r1:7b"];
      #port = 11434; changing this breaks the cli
      openFirewall = true;
    };
    open-webui = {
      # Open Web UI
      enable = true;
      #port = 9001;
      openFirewall = true;
    };
  };
}
