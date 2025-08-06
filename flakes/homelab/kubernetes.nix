{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.homelab.kubernetes;
in
{
  options.homelab.kubernetes = {
    enable = lib.mkEnableOption "Enable Kubernetes cluster";
    asMaster = lib.mkEnableOption "Run Kubernetes as a master node, otherwise as a worker node";
    masterIP = lib.mkOption {
      type = lib.types.str;
      description = "IP address of the Kubernetes master node";
    };
    masterHostname = lib.mkOption {
      type = lib.types.str;
      description = "Hostname of the Kubernetes master node";
    };
    masterServerPort = lib.mkOption {
      type = lib.types.port;
      default = 6443;
      description = "Port for the Kubernetes API server";
    };
    apitokenPath = lib.mkOption {
      type = lib.types.path;
      description = "Path to the file containing the Kubernetes API token";
    };

    # nodeIP = lib.mkOption {
    # 	type = lib.types.str;
    # 	description = "IP address of the Kubernetes worker node";
    # };
    # nodeHostname = lib.mkOption {
    # 	type = lib.types.str;
    # 	description = "Hostname of the Kubernetes worker node";
    # };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kompose
      kubectl
      kubernetes
    ];
    # Ensure k8s worker node can join the cluster
    systemd.services."kubernetes-join-cluster" = lib.mkIf (!cfg.asMaster) {
      path =
        let
          top = config.services.kubernetes;
          certmgrAPITokenPath = "${top.secretsPath}/apitoken.secret";
          cfsslAPITokenLength = 32; # Length of the API token
        in
        [
          (pkgs.writeScriptBin "nixos-kubernetes-node-join" ''
            set -e
            exec 1>&2

            if [ $# -gt 0 ]; then
              echo "Usage: $(basename $0)"
              echo ""
              echo "No args. Apitoken must be provided on stdin."
              echo "To get the apitoken, execute: 'sudo cat ${certmgrAPITokenPath}' on the master node."
              exit 1
            fi

            if [ $(id -u) != 0 ]; then
              echo "Run as root please."
              exit 1
            fi

            read -r token
            if [ ''${#token} != ${toString cfsslAPITokenLength} ]; then
              echo "Token must be of length ${toString cfsslAPITokenLength}."
              exit 1
            fi

            install -m 0600 <(echo $token) ${certmgrAPITokenPath}

            echo "Restarting certmgr..." >&1
            systemctl restart certmgr

            echo "Waiting for certs to appear..." >&1

            ${lib.strings.optionalString top.kubelet.enable ''
              while [ ! -f ${top.pki.certs.kubelet.cert} ]; do sleep 1; done
              echo "Restarting kubelet..." >&1
              systemctl restart kubelet
            ''}

            ${lib.strings.optionalString top.proxy.enable ''
              while [ ! -f ${top.pki.certs.kubeProxyClient.cert} ]; do sleep 1; done
              echo "Restarting kube-proxy..." >&1
              systemctl restart kube-proxy
            ''}

            ${lib.strings.optionalString top.flannel.enable ''
              while [ ! -f ${top.pki.certs.flannelClient.cert} ]; do sleep 1; done
              echo "Restarting flannel..." >&1
              systemctl restart flannel
            ''}

            echo "Node joined successfully"
          '')
        ];
      description = "oneshot systemd service to join the kubernetes cluster";
      script =
        let
          apitoken-secret = cfg.apitokenPath;
        in
        ''
          #!/bin/sh
          set -e
          if [ ! -f ${apitoken-secret} ]; then
            echo "Error: API token file ${apitoken-secret} does not exist."
            exit 1
          fi
          if ! command -v nixos-kubernetes-node-join >/dev/null 2>&1; then
            echo "Error: nixos-kubernetes-node-join not found in PATH"
            exit 1
          fi
          TOKEN=$(cat ${apitoken-secret})
          echo $TOKEN | nixos-kubernetes-node-join
        '';
      after = [
        config.systemd.services.kubelet.name
      ];
      wantedBy = [ "kubernetes.target" ];
    };
    services.kubernetes =
      let
        api = "https://${cfg.masterHostname}:${toString cfg.masterServerPort}";
      in
      {
        roles = [ "node" ] ++ lib.optional cfg.asMaster "master";
        apiserverAddress = api;
        apiserver = lib.mkIf cfg.asMaster {
          securePort = cfg.masterServerPort;
          advertiseAddress = cfg.masterIP;
        };
        masterAddress = cfg.masterHostname;
        easyCerts = true;
        #caFile =
        addons.dns.enable = true;
        # for swap, may not need this.
        kubelet.extraOpts = "--fail-swap-on=false";

        kubelet.kubeconfig = {
          server = api;
        };
      };
  };
}
