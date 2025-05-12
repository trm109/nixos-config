{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.services.homelab;
in
{
  imports = [
    ./adguardhome.nix
    ./home-assistant.nix
    ./grafana.nix
    ./glance.nix
    ./teslamate.nix
    ./tailscale.nix
    ./kubernetes.nix
  ];
  options.modules.services.homelab = {
    enable = lib.mkOption {
      default = false;
      description = "Enable the services module";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = "${config.networking.hostName}.lan";
      description = "Local network domain name";
    };
    tailScaleDomain = lib.mkOption {
      type = lib.types.str;
      default = "${config.networking.hostName}.lan";
      description = "Tailscale network domain name";
    };
    useHttps = lib.mkOption {
      default = true;
      description = "Use https for the services";
    };
    forceHttps = lib.mkOption {
      default = true;
      description = "Force https for the services";
    };
    sslCertFile = lib.mkOption {
      # path or null
      type = lib.types.path or lib.types.null;
      default = null;
      description = "Path to the ssl cert file";
    };
  };
  config = lib.mkIf cfg.enable {
    modules.services.homelab = {
      adguardhome.enable = true;
      grafana.enable = true;
      glance.enable = true;
      home-assistant.enable = true;
      teslamate.enable = true;
      tailscale.enable = true;
    };
    services.nginx = {
      enable = true;
      statusPage = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts.${cfg.domain} = {
        enableACME = cfg.useHttps;
        addSSL = cfg.useHttps && !cfg.forceHttps;
        onlySSL = cfg.forceHttps;
        #addSSL = cfg.https;
        #forceSSL = cfg.https;
        # can be overridden
        extraConfig = ''
          proxy_buffering off;
        '';
        locations."/" = lib.mkDefault {
          return = "200 '<html><body>It works</body></html>'";
          extraConfig = ''
            default_type text/html;
          '';
        };
      };
    };
    security.acme = {
      acceptTerms = true;
      defaults = {
        email = "theo@bionix.fyi";
        #dnsResolver = "127.0.0.1:53"; #TODO this should be 100.x.x.x on tailscale, but 192.168.x.x on the local network
        dnsProvider = "manual";
        #TODO implement cfg.sslCertFile here
      };
    };
    networking.firewall.allowedTCPPorts = [
      # HTTP
      80
      # HTTPS
      443
    ];
    users.users.nginx.extraGroups = [ "acme" ];
  };
}
