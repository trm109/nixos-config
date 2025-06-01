{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.system.nix.hostBuilder;
in
{
  # based on https://nix.dev/tutorials/nixos/distributed-builds-setup.html#distributed-builds-config-nixos
  options.modules.system.nix.hostBuilder = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Nix host builder for local builds.";
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings.trusted-users = [ "remotebuild" ];
    users = {
      users.remotebuild = {
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
      groups.remotebuild = { };
    };
  };
}
