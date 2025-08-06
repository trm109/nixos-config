{
  age.secrets = {
    kubernetes-apitoken = {
      file = ./homelab/kubernetes/apitoken.age;
    };
    tailscale-auth-key.file = ./tailscale/auth_key.age;
    # k3s-token.file = ./homelab/k3s-token.age;
    # k8s-apitoken = {
    #   file = ./homelab/k8s-apitoken.age;
    #   path = "/var/lib/kubernetes/secrets/apitoken.secret";
    # };
  };
}
