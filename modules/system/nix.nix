{
  inputs,
  lib,
  config,
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
      };
      extraOptions = ''
        extra-substituters = https://devenv.cachix.org
        extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
        builders-use-substitutes = true
        trusted-users = root saik
      '';
      buildMachines = [
        {
          hostName = "builder";
          system = "x86_64-linux";
          protocol = "ssh-ng";
          # if the builder supports building for multiple architectures,
          # replace the previous line by, e.g.
          # systems = ["x86_64-linux" "aarch64-linux"];
          maxJobs = 1;
          speedFactor = 2;
          supportedFeatures = [
            "nixos-test"
            "benchmark"
            "big-parallel"
          ];
          mandatoryFeatures = [ ];
        }
      ];
      distributedBuilds = true;
    };
  };
}
