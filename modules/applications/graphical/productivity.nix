{
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.applications.graphical.productivity;
in
{
  options.modules.applications.graphical.productivity = {
    enable = lib.mkOption {
      default = false;
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
      chromium # backup, chromium based browser.
      stremio # Video Player + Torrent Streaming
      stable.libreoffice # office suite
      darktable # Photo editing
      blender-hip # 3d modeling software
      cheese # simple camera app, for testing mostly
      mailspring # email client
      vial # QMK keyboard configuration TODO branch off
      mpv # video player, supports hdr
      kdePackages.filelight # Disk Usage Analyzer
      bitwarden # password manager
      insomnia # REST client
    ];
    programs = {
      # Thunar dependencies
      gvfs = {
        enable = true;
      };
      tumbler = {
        enable = true;
      };
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
        ];
      };
      #xfconf.enable = true; #TODO test if this is needed
    };
  };
}
