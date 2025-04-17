{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.services.homelab.teslamate;
  teslamate-grafana-dashboards = pkgs.stdenv.mkDerivation rec {
    pname = "teslamate-grafana-dashboards";
    version = "1.33.0";

    src = pkgs.fetchFromGitHub {
      owner = "teslamate-org";
      repo = "teslamate";
      rev = "v${version}";
      hash = "sha256-yDAYft2/91lLLKSKrejlIQBrYZVFF6BA1J0hE7w+OF4=";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p "$out"
      cp "$src"/grafana/dashboards.yml "$out"
      cp -r "$src"/grafana/dashboards "$out"
    '';
  };
in
{
  options.modules.services.homelab.teslamate = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.services.homelab.home-assistant.enable || false;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets = {
      #teslamate_encryption.file = ../../secrets/teslamate_encryption.age;
      teslamate_db.file = ../../secrets/teslamate_db.age;
      teslamate_mqtt.file = ../../secrets/teslamate_mqtt.age;
      teslamate.file = ../../secrets/teslamate.age;
    };

    systemd.services."teslamate-bootstrap" = {
      preStart = ''
        mkdir -p /var/lib/teslamate

        chown -R teslamate /var/lib/teslamate
      '';
    };

    virtualisation.oci-containers = {
      backend = "podman";
      containers = {
        "teslamate" = {
          image = "docker.io/teslamate/teslamate:latest";
          environmentFiles = [
            config.age.secrets.teslamate.path
          ];
          #environment = {
          #  #DATABASE_USER = "teslamate";
          #  #DATABASE_NAME = "teslamate";
          #  #DATABASE_HOST = "127.0.0.1";
          #  #MQTT_HOST = "192.168.50.3"; # TODO replace with DDNS address?
          #  #MQTT_USERNAME = "teslamate";
          #  #TZ = "America/New_York";
          #};
          extraOptions = [
            "--cap-drop=ALL"
            "--network=host"
          ];
          ports = [ "4000:4000" ];
          dependsOn = [ "tesla-db" ];
        };
        "tesla-db" = {
          image = "docker.io/postgres:latest";
          environmentFiles = [
            config.age.secrets.teslamate.path
          ];
          #environment = {
          #  #POSTGRES_USER = "teslamate";
          #  #POSTGRES_PASSWORD = "" from secrets/teslamate.age
          #  #POSTGRES_DB = "teslamate";
          #};
          ports = [ "5432:5432" ];
          volumes = [
            "/var/lib/teslamate/data:/var/lib/postgresql/data" # TODO systemd server to create this folder
          ];
          extraOptions = [
            "--network=host"
          ];
        };
        "tesla-mqtt" = {
          image = "docker.io/eclipse-mosquitto:latest";
          entrypoint = "mosquitto -c /mosquitto/config/mosquitto.conf";
          extraOptions = [
            "--network=host"
          ];
          volumes = [
            "/var/lib/teslamate/mosquitto-conf:/mosquitto/config"
            "/var/lib/teslamate/mosquitto-data:/mosquitto/data"
          ];
        };
        "tesla-grafana" = {
          image = "docker.io/teslamate/grafana:latest";
          environmentFiles = [
            config.age.secrets.teslamate.path
          ];
          ports = [ "3000:3000" ];
          extraOptions = [
            "--network=host"
          ];
          #workdir = "/var/lib/teslamate/grafana";
          volumes = [
            "/var/lib/teslamate/grafana:/var/lib/grafana"
            "/var/lib/teslamate/grafana/plugins:/var/lib/grafana/plugins"
            "/var/lib/teslamate/grafana/grafana.db:/var/lib/grafana/grafana.db"
          ];
        };
      };
    };
    users = {
      users."teslamate" = {
        isSystemUser = true;
        group = "teslamate";
      };
      groups."teslamate" = { };
    };

    #services.postgresql = {
    #  enable = lib.mkDefault true;

    #  ensureDatabases = [ "teslamate" ];
    #  ensureUsers = [
    #    {
    #      name = "teslamate";
    #      ensureDBOwnership = true;
    #    }
    #  ];
    #  enableTCPIP = true;

    #  authentication = ''
    #    # Generated file; do not edit!
    #    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    #    local   all             all                                     trust
    #    host    all             all             127.0.0.1/32            trust
    #    host    all             all             ::1/128                 trust
    #  '';
    #  initialScript = pkgs.writeText "teslamate-initial-script" ''
    #    GRANT ALL PRIVILEGES ON DATABASE teslamate TO teslamate;
    #    CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public
    #    CREATE EXTENSION IF NOT EXISTS earthdistance WITH SCHEMA public
    #  '';
    #  identMap = ''
    #    # Arbitraty Name    systemUser DBUser
    #    superuser_map       teslamate teslamate
    #    superuser_map       root      teslamate
    #  '';
    #};

    services.mosquitto = {
      enable = lib.mkDefault true;
      listeners = [
        {
          users = {
            teslamate = {
              acl = [ "readwrite teslamate/#" ];
              passwordFile = config.age.secrets.teslamate_mqtt.path;
            };
          };
        }
      ];
    };

    services.grafana = {
      enable = lib.mkDefault true;

      settings.server = {
        domain = "grafana.murray-hill.asuscomm.com";
        http_port = 3000;
        http_addr = "0.0.0.0";
      };

      provision = {
        enable = true;

        datasources = {
          settings.datasources = [
            {
              name = "TeslaMate";
              type = "postgres";
              access = "proxy";
              url = "localhost:5432";
              username = "teslamate";
              database = "teslamate";
              secureJsonData = {
                password = "$__file{${config.age.secrets.teslamate_db.path}}";
              };
              jsonData = {
                postgresVersion = "1400";
                sslmode = "disable";
              };
            }
          ];
        };

        dashboards = {
          settings.providers = [
            {
              name = "teslamate";
              orgId = 1;
              folder = "TeslaMate";
              folderUid = "Nr4ofiDZk";
              type = "file";
              disableDeletion = false;
              editable = true;
              updateIntervalSeconds = 86400;
              options.path = "${teslamate-grafana-dashboards}/dashboards";
            }
            {
              name = "teslamate_internal";
              orgId = 1;
              folder = "TeslaMate/Internal";
              folderUid = "Nr5ofiDZk";
              type = "file";
              disableDeletion = false;
              editable = true;
              updateIntervalSeconds = 86400;
              options.path = "${teslamate-grafana-dashboards}/dashboards/internal";
            }
            {
              name = "teslamate_reports";
              orgId = 1;
              folder = "TeslaMate/Reports";
              folderUid = "Nr6ofiDZk";
              type = "file";
              disableDeletion = false;
              allowUiUpdates = true;
              updateIntervalSeconds = 86400;
              options.path = "${teslamate-grafana-dashboards}/dashboards/reports";
            }
          ];
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 4000 ];
  };
}
