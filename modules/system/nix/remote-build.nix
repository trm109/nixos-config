{
  lib,
  config,
  pkgs,
  hostType,
  ...
}:
let
  cfg = config.modules.system.nix.remoteBuild;
in
{
  options.modules.system.nix.remoteBuild = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = hostType == "server";
      description = "Enable remote builds using Nix on a remote machine.";
    };
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings.builders-use-substitutes = true;
      distributedBuilds = true;
      buildMachines = [
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
    services.openssh.knownHosts = {
      # TODO parameterize this
      viceroy.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICppn/DPe6WPH6JXAP+cIb8qsHVR6fgD6YpS11cuF4N2"; # viceroy
    };
  };
}
