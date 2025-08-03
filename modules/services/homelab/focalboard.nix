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
  };

  config = lib.mkIf cfg.enable {
    virtualisation.oci-containers.containers.focalboard = {
      image = "mattermost/focalboard:latest";
      ports = [ "127.0.0.1:3128:8000" ];
      # fbdata:/opt/focalboard/data
      volumes = [
        "fbdata:/opt/focalboard/data"
      ];
    };
  };
}
