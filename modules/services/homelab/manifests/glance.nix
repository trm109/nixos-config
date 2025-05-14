{
  apiVersion = "helm.cattle.io/v1";
  kind = "HelmChart";
  metadata = {
    name = "glance";
    #namespace = "apps";
    namespace = "kube-system";
  };
  spec = {
    chart = "glance";
    version = "0.0.4";
    repo = "https://rubxkube.github.io/charts/";
  };
}
