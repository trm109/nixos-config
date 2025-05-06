{
  inputs,
  lib,
  config,
  users,
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
    #enableRemoteBuilds = lib.mkOption {
    #  default = true;
    #  description = "Enable remote builds";
    #};
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
      #extraOptions = ''
      #  builders-use-substitutes = true
      #'';
      buildMachines = lib.mkForce [ ];
      #buildMachines = [
      #  {
      #    hostName = "viceroy";
      #    system = "x86_64-linux";
      #    sshUser = "nixremote";
      #    sshKey = pubKeys.hosts.${hostname};
      #    # if the builder supports building for multiple architectures,
      #    # replace the previous line by, e.g.
      #    # systems = ["x86_64-linux" "aarch64-linux"];
      #    maxJobs = 1;
      #    speedFactor = 2;
      #    supportedFeatures = [
      #      "nixos-test"
      #      "benchmark"
      #      "big-parallel"
      #    ];
      #    mandatoryFeatures = [ ];
      #  }
      #];
      #distributedBuilds = true;
    };
  };
}
