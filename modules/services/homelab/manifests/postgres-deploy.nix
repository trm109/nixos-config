{
  apiVersion = "apps/v1";
  kind = "Deployment";
  metadata = {
    name = "postgres";
    namespace = "homelab";
    labels = {
      app = "postgres";
    };
  };
  spec = {
    replicas = 1;
    selector = {
      matchLabels = {
        app = "postgres";
      };
    };
    template = {
      metadata = {
        labels = {
          app = "postgres";
        };
      };
      spec = {
        containers = [
          {
            name = "postgres";
            image = "postgres:latest";
            ports = [
              {
                containerPort = 5432;
              }
            ];
            env = [
              {
                name = "POSTGRES_USER";
                value = "postgres";
              }
              {
                name = "POSTGRES_PASSWORD";
                value = "password";
              }
            ];
          }
        ];
        volumes = [
          {
            name = "postgres-storage";
            persistentVolumeClaim = {
              claimName = "postgres-pvc";
            };
          }
        ];
      };
    };
  };
}
