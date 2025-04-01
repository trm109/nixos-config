{
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.applications.graphical.gaming;
in
{
  options.modules.applications.graphical.gaming = {
    enable = lib.mkOption {
      default = false;
      description = ''
        Enable gaming applications.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      steam-run
      protonup-qt
      mangohud
      nvtopPackages.full
      goverlay
      (prismlauncher.override {
        jdks = [
          jdk8
          jdk17
          jdk21
        ];
      })
      (r2modman.overrideAttrs (
        let
          src = pkgs.fetchFromGitHub {
            owner = "ebkr";
            repo = "r2modmanPlus";
            rev = "59c1fe5287593eb58b4ce6d5d8f2ca59ca64bfd4";
            hash = "sha256-1b24tclqXGx85BGFYL9cbthLScVWau2OmRh9YElfCLs=";
          };
        in
        {
          inherit src;
          offlineCache = pkgs.fetchYarnDeps {
            yarnLock = "${src}/yarn.lock";
            hash = "sha256-3SMvUx+TwUmOur/50HDLWt0EayY5tst4YANWIlXdiPQ=";
          };
        }
      ))
    ];

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers.
        extest.enable = true; # Whether to enable Load the extest library into Steam, to translate X11 input events to uinput events (e.g. for using Steam Input on Wayland)
        protontricks.enable = true; # Enable ProtonTricks
        gamescopeSession = {
          enable = true;
          args = [
            "--output-width"
            "3840"
            "--output-height"
            "2160"
            "--framerate-limit"
            "60"
            "--steam"
            "--hdr-enabled"
            "--hdr-itm-enable"
            "--prefer-output"
            "DP-1" # TODO make this dynamic
            "--prefer-vk-device"
            "1002:744c" # TODO make this dynamic
          ];
        };
      };
      gamescope = {
        enable = true;
      };
      gamemode = {
        enable = true;
      };
    };

    services = {
      input-remapper = {
        enable = true;
        enableUdevRules = true;
      };
    };
  };
}
