{
  config,
  lib,
  ...
}:
let
  cfg = config.kubernetes;
in
{
  options.kubernetes = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Kubernetes configuration.";
    };
    nodes = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            ip = lib.mkOption {
              type = lib.types.str;
              description = "LAN IP address of the node.";
            };
            fqdn = lib.mkOption {
              type = lib.types.str;
              description = "Fully Qualified Domain Name for the node.";
            };
            hostname = lib.mkOption {
              type = lib.types.str;
              description = "Hostname of the node.";
            };
            role = lib.mkOption {
              type = lib.types.enum [
                "master"
                "worker"
              ];
              default = "worker";
              description = "Role of the node in the Kubernetes cluster.";
            };
          };
        }
      );
      default = { };
      description = "Configuration for each Kubernetes node.";
    };
  };
  config = lib.mkIf cfg.enable {

    ## Each machine
    # Packages

    # https://github.com/kelseyhightower/kubernetes-the-hard-way/blob/master/docs/03-compute-resources.md
    # Set each Machine's FQDN
    networking.domain = lib.mkForce "kubernetes.cluster"; # TODO: check if this is needed. Maybe we can reference instead of setting it.
    # Add a /etc/hosts entry for each machine in the cluster. Appends "<ip> <fqdn> <hostname>" to /etc/hosts
    networking.extraHosts = lib.mapAttrsToList (
      attrs: "${attrs.ip} ${attrs.fqdn} ${attrs.hostname}"
    ) cfg.nodes;

    ## master only

    ## worker only
  };
}
