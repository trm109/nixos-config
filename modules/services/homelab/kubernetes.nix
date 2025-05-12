{ lib, config, ... }:
let
  cfg = config.modules.services.homelab.kubernetes;
in
{
  options = {
    modules.services.homelab.kubernetes = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the Kubernetes service.";
      };
      isMaster = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Is this node a master node?";
      };
      masterHostname = lib.mkOption {
        type = lib.types.str;
        description = "The hostname of the master node.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.k3s = {
      enable = true;
      role = if cfg.isMaster then "server" else "agent";
      serverAddr = "https://${cfg.masterHostname}:6443";
      tokenFile = config.age.secrets.k3s-token.path;
    };
  };
}
