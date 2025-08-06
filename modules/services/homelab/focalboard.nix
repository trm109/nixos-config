{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.services.homelab.focalboard;
in
{
  options.modules.services.homelab.focalboard = {
    enable = lib.mkEnableOption "focalboard service";
    port = lib.mkOption {
      type = lib.types.port;
      default = 3128;
      description = "Port on which Focalboard will be available.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Focalboard is a self-hosted project management tool from Mattermost.
    virtualisation.oci-containers.containers.focalboard = {
      image = "mattermost/focalboard:latest";
      ports = [ "127.0.0.1:${toString cfg.port}:8000" ];
      # fbdata:/opt/focalboard/data
      volumes = [
        "fbdata:/opt/focalboard/data"
      ];
    };
    # make available on local networks.
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
