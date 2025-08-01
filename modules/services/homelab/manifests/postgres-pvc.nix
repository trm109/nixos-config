{
  apiVersion = "v1";
  kind = "PersistentVolumeClaim";
  metadata = {
    name = "postgres-pvc";
  };
  spec = {
    accessModes = [ "ReadWriteOnce" ];
    resources = {
      requests = {
        storage = "5Gi";
      };
    };
    storageClassName = "local-path";
  };
}
