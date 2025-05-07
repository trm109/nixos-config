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
    virtualisation.oci-containers.containers =
      let
        db_user = "teslamate";
        db_name = "teslamate";
        db_host = "database";
        mqtt_host = "mosquitto";
      in
      {
        teslamate = {
          image = "teslamate/teslamate:latest";
          restartPolicy = "always";
          ports = [ "4000:4000" ];
          volumes = [
            "./import:/opt/app/import"
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
          extraOptions = [ "--cap-drop=all" ];
        };

        teslamate-db = {
          image = "postgres:17";
          restartPolicy = "always";
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
        };

        teslamate-grafana = {
          image = "teslamate/grafana:latest";
          restartPolicy = "always";
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
        };

        teslamate-mqtt = {
          image = "eclipse-mosquitto:2";
          restartPolicy = "always";
          command = [
            "mosquitto"
            "-c"
            "/mosquitto-no-auth.conf"
          ];
          volumes = [
            "mosquitto-conf:/mosquitto/config"
            "mosquitto-data:/mosquitto/data"
          ];
        };
      };
    networking.firewall.allowedTCPPorts = [ 4000 ];
  };
}
