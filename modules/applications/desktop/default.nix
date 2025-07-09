# Settings specific to devices with a desktop environment
{
  hostType,
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.applications.desktop;
in
{
  imports = [
    ./wayland
    ./x11
  ];

  options.modules.applications.desktop = {
    enable = lib.mkOption {
      # if wayland or x11 is enabled, enable desktop by default.
      # if hostType is desktop, enable desktop by default.
      # else false
      default = cfg.wayland.enable || cfg.x11.enable || hostType == "desktop";
      description = "Enable the desktop applications module";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      # Display manager
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

    environment = {
      sessionVariables = {
        # Set the default session to Wayland if available, otherwise X11
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
        XDG_MUSIC_DIR = "$HOME/Music";
        XDG_PICTURES_DIR = "$HOME/Pictures";
        XDG_VIDEOS_DIR = "$HOME/Videos";
        XDG_DOCUMENTS_DIR = "$HOME/Documents";
        XDG_DOWNLOAD_DIR = "$HOME/Downloads";
        XDG_DESKTOP_DIR = "$HOME/Desktop";
      };
      systemPackages = with pkgs; [
        brightnessctl # Ability to change brightness of various devices, keyboards included # TODO make available if laptop
        libnotify # notification utility
      ];
    };

    xdg = {
      mime = {
        enable = true;
      };
    };

    programs = {
      # Mobile device connectivity
      kdeconnect = {
        enable = true;
      };
    };
  };
}
