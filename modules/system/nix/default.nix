{
  inputs,
  lib,
  config,
  users,
  pkgs,
  ...
}:
let
  cfg = config.modules.system.nix;
in
{
  imports = [
    ./host-builder.nix
    ./remote-build.nix
  ];
  options.modules.system.nix = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the nix module";
    };
    autoUpdate = lib.mkOption {
      default = true;
      description = "Enable automatic updates from git repo";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.agenix.packages."x86_64-linux".default # TODO make this dynamic based on arch
    ];
    # nix (packages)
    nixpkgs = {
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "dotnet-runtime-7.0.20"
        ];
      };
    };
    # nix (package manager)
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than +5";
      };
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        auto-optimise-store = true;
        trusted-users = [
          "root"
        ] ++ users;
        substituters = [
          "https://nix-community.cachix.org"
          "https://hyprland.cachix.org"
          "https://devenv.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8ZY7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        ];
      };
    };

    # Automatic update systemd timer
    systemd.timers."nix-auto-update" = {
      description = "Nix auto update timer";
      wantedBy = [ "timers.target" ];
      # run every 30 minutes, give or take 1 minute, accuracy is not important
      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "30min";
        RandomizedDelaySec = "1min";
        AccuracySec = "15s";
      };
    };
    systemd.services."nix-auto-update" = {
      enable = true;
      description = "Nix auto update service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [
        pkgs.git
      ];
      serviceConfig = {
        Type = "oneshot";
      };
      script = ''
        set -euo pipefail
        echo "Starting Nix auto update service..."
        TARGET_DIR="/etc/nixos"
        export HOME="/tmp"
        git config --global --add safe.directory "$TARGET_DIR"
        echo "Fetching latest changes from git repository..."
        git -C "$TARGET_DIR" fetch

        LOCAL="$(git -C "$TARGET_DIR" rev-parse @)"
        REMOTE="$(git -C "$TARGET_DIR" rev-parse @{u})"
        BASE="$(git -C "$TARGET_DIR" merge-base @ @{u})"

        if [ "$LOCAL" = "$REMOTE" ]; then
          echo "Repository is up to date."
          exit 0
        elif [ "$LOCAL" = "$BASE" ]; then
          echo "Repository is behind. Pulling..."
          git -C "$TARGET_DIR" pull
          echo "Repository updated, running nixos-rebuild switch..."
          nixos-rebuild switch --flake "$TARGET_DIR#$(cat /etc/hostname)"
          echo "NixOS rebuild completed."
          exit 0
        elif [ "$REMOTE" = "$BASE" ]; then
          echo "Repository is ahead of remote."
          exit 1
        else
          echo "Repository has diverged."
          exit 1
        fi
      '';
    };
    # Automatic update systemd service
  };
}
