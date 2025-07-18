{
  apiVersion = "v1";
  kind = "Service";
  metadata = {
    name = "postgres";
    labels = {
      app = "postgres";
    };
  };
  spec = {
    ports = [
      {
        name = "postgres";
        port = 5432;
        targetPort = 5432;
      }
    ];
    selector = {
      app = "postgres";
    };
    type = "ClusterIP";
  };
}
