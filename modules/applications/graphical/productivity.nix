{
  lib,
  pkgs,
  config,
  hostType,
  ...
}:
let
  cfg = config.modules.applications.graphical.productivity;
in
{
  options.modules.applications.graphical.productivity = {
    enable = lib.mkOption {
      default = hostType == "desktop" || false;
      description = ''
        Enable graphical, productivity applications.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # graphical, productivity applications
    environment.systemPackages = with pkgs; [
      kitty # Terminal Emulator
      webcord-vencord # Discord client, but better
      spotube # Spotify client
      librewolf # firefox-based browser
      ungoogled-chromium # backup, chromium based browser.
      stremio # Video Player + Torrent Streaming
      stable.libreoffice # office suite
      darktable # Photo editing
      #blender-hip # 3d modeling software
      cheese # simple camera app, for testing mostly
      thunderbird # email client
      mpv # video player, supports hdr
      kdePackages.filelight # Disk Usage Analyzer
      bitwarden # password manager
      insomnia # REST client
      github-desktop # GitHub client
      super-productivity
    ];
    services = {
      gvfs = {
        enable = true;
      };
      tumbler = {
        enable = true;
      };
    };
    programs = {
      # Thunar dependencies
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
      #xfconf.enable = true; #TODO test if this is needed
      obs-studio = {
        enable = true;
        plugins = [ pkgs.obs-studio-plugins.wlrobs ];
        enableVirtualCamera = true;
      };
    };
  };
}
