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
  options.modules.system.nix = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the nix module";
    };
    enableRemoteBuilds = lib.mkOption {
      default = !config.modules.system.nix.isHostBuilder;
      description = "Enable remote builds";
    };
    isHostBuilder = lib.mkOption {
      default = false;
      description = "Is this host a remote build machine?";
    };
  };

  config = lib.mkIf cfg.enable {
    #programs.ssh.knownHosts = lib.mkIf cfg.enableRemoteBuilds {
    #  plex-0 = {
    #    hostNames = [
    #      "plex-0"
    #      "plex-0.${config.networking.domain}"
    #    ];
    #    publicKey = pubKeys.hosts.plex-0;
    #  };
    #  viceroy = {
    #    hostNames = [
    #      "viceroy"
    #      "viceroy.${config.networking.domain}"
    #    ];
    #    publicKey = pubKeys.hosts.viceroy;
    #  };
    #};
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
        trusted-users =
          [
            "root"
          ]
          ++ users
          ++ lib.optionals cfg.isHostBuilder [
            "remotebuild"
          ];
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
        builders-use-substitutes = lib.mkIf cfg.enableRemoteBuilds true;
      };
      distributedBuilds = lib.mkIf cfg.enableRemoteBuilds true;
      buildMachines = lib.mkIf cfg.enableRemoteBuilds [
        {
          hostName = "viceroy"; # TODO parameterize this
          sshUser = "remotebuild";
          sshKey = "/etc/ssh/ssh_host_ed25519_key"; # TODO parameterize this
          inherit (pkgs.stdenv.hostPlatform) system;
          supportedFeatures = [
            "nixos-test"
            "big-parallel"
            "kvm"
          ];
        }
      ];
    };

    #buildMachines = lib.mkForce [ ];
    # cfg.enableRemoteBuilds
    services.openssh.knownHosts = lib.mkIf cfg.enableRemoteBuilds {
      # TODO parameterize this
      viceroy.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICppn/DPe6WPH6JXAP+cIb8qsHVR6fgD6YpS11cuF4N2"; # viceroy
    };
    nix = {
    };
    # cfg.isHostBuilder
    users = {
      users.remotebuild = lib.mkIf cfg.isHostBuilder {
        isNormalUser = true;
        createHome = false;
        group = "remotebuild";
        description = "Remote build user";
        shell = lib.mkForce pkgs.bash;

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNNE769ehQ8NoDm/tcz/oafehsysGN0taoLfafuha0A" # plex-0
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYob0+sv/2ZHTzNFZxLTVpTOnuHRpA+c/xyn2a/m01p" # plex-1
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6+ijDF6zaCnlDzCL7wZC+V9mhL1RV5BBVxcuO0rqIU" # plex-2
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQrIk6JHcuxlQ4EWXr+DuvIuaBMF2VlcPoMLtXeY1Rb" # plex-3
        ];
      };
      groups.remotebuild = lib.mkIf cfg.isHostBuilder { };
    };
  };
}
