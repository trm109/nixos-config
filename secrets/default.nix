{
  age.secrets = {
    tailscale_auth_key.file = ./tailscale/auth_key.age;
    teslamate-core-env.file = ./homelab/teslamate-core-env.age;
    teslamate-db-env.file = ./homelab/teslamate-db-env.age;
    teslamate-grafana-env.file = ./homelab/teslamate-grafana-env.age;
    k3s-token.file = ./homelab/k3s-token.age;
  };
}
