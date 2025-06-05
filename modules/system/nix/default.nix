{
  inputs,
  lib,
  config,
  users,
  pkgs,
  hostType,
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
      default = hostType == "server";
      description = "Enable automatic updates from git repo";
    };
    autoReboot = lib.mkOption {
      default = hostType == "server";
      description = "Enable periodic reboots";
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

    systemd = {
      timers = {
        # Automatic update systemd timer
        "nix-auto-update" = {
          enable = cfg.autoUpdate;
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

        # Automatic reboot systemd timer, everyday at 4 AM
        "nix-auto-reboot" = {
          enable = cfg.autoReboot;
          description = "Nix auto reboot timer";
          wantedBy = [ "multi-user.target" ];
          timerConfig = {
            OnCalendar = "*-*-* 04:00";
          };
        };
      };
      # Automatic update systemd service
      services = {
        "nix-auto-update" = {
          enable = cfg.autoUpdate;
          description = "Nix auto update service";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          path = [
            pkgs.git
            pkgs.nixos-rebuild
            pkgs.nix-janitor
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
            elif [ "$LOCAL" = "$BASE" ]; then
              echo "Repository is behind. Pulling..."
              git -C "$TARGET_DIR" pull
              echo "Repository updated!"
            elif [ "$REMOTE" = "$BASE" ]; then
              echo "Repository is ahead of remote. Please correct this manually."
              exit 1
            else
              echo "Repository has diverged. Please correct this manually."
              exit 1
            fi

            # Get the current configuration revision
            CONFIG_REV="$(/run/current-system/sw/bin/nixos-version --configuration-revision)"

            # Compare configuration revision against the current HEAD
            if [ "$CONFIG_REV" != "$(git -C "$TARGET_DIR" rev-parse HEAD)" ]; then
              echo "Configuration has changed, applying changes..."
              echo "Rebuilding system..."
              nixos-rebuild switch --flake "$TARGET_DIR#$(hostname)"
              echo "System rebuilt successfully!"
              echo "Cleaning up old generations..."
              janitor
              echo "Old generations cleaned up!"
              exit 0
            else
              echo "No changes to apply."
              exit 0
            fi
          '';
        };

        # Automatic reboot systemd service
        "nix-auto-reboot" = {
          enable = cfg.autoReboot;
          description = "Auto reboot service";
          serviceConfig = {
            Type = "oneshot";
          };
          script = ''
            set -euo pipefail
            echo "Starting Nix auto reboot service..."
            echo "Rebooting system..."
            ${pkgs.systemd}/bin/systemctl reboot
          '';
        };
      };
    };
  };
}
