{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.services.homelab.teslamate;
in
{
  options.modules.services.homelab.teslamate = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.services.homelab.enable || false;
    };
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    virtualisation.oci-containers.containers =
      let
        db_user = "teslamate";
        db_name = "teslamate";
        db_host = "teslamate-db";
        mqtt_host = "mosquitto";
      in
      rec {
        teslamate = {
          image = "teslamate/teslamate:latest";
          ports = [ "4000:4000" ];
          volumes = [
            "teslamate-import:/var/lib/teslamate/import"
          ];
          environment = {
            #ENCRYPTION_KEY = tesla_encryption_key;
            DATABASE_USER = db_user;
            #DATABASE_PASS = db_pass;
            DATABASE_NAME = db_name;
            DATABASE_HOST = db_host;
            MQTT_HOST = mqtt_host;
          };
          environmentFiles = [
            config.age.secrets.teslamate-core-env.path
          ];
          extraOptions = [
            "--cap-drop=all"
          ];
          autoStart = true;
        };

        teslamate-db = {
          image = "postgres:17";
          volumes = [
            "teslamate-db:/var/lib/postgresql/data"
          ];
          environment = {
            POSTGRES_USER = db_user;
            #POSTGRES_PASSWORD = db_pass;
            POSTGRES_DB = db_name;
          };
          environmentFiles = [
            config.age.secrets.teslamate-db-env.path
          ];
          extraOptions = [
          ];
        };

        teslamate-grafana = {
          image = "teslamate/grafana:latest";
          ports = [ "3000:3000" ];
          volumes = [
            "teslamate-grafana-data:/var/lib/grafana"
          ];
          environment = {
            DATABASE_USER = db_user;
            #DATABASE_PASS = db_pass;
            DATABASE_NAME = db_name;
            DATABASE_HOST = db_host;
          };
          environmentFiles = [
            config.age.secrets.teslamate-grafana-env.path
          ];
          extraOptions = [
          ];
        };

        teslamate-mqtt = {
          image = "eclipse-mosquitto:2";
          cmd = [
            "mosquitto"
            "-c"
            "/mosquitto-no-auth.conf"
          ];
          volumes = [
            "mosquitto-conf:/mosquitto/config"
            "mosquitto-data:/mosquitto/data"
          ];
          extraOptions = [
          ];
        };
      };
    networking.firewall.allowedTCPPorts = [ 4000 ];
  };
}
