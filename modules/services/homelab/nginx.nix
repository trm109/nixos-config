{ config, lib, ... }:
let
  cfg = config.modules.services.homelab.nginx;
in
{
  options.modules.services.homelab.nginx = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable nginx";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      description = "Domain name for nginx";
    };
    https = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable https";
    };
    useSubnet = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Use a self-signed certificate for the nginx server";
    };
  };

  config = lib.mkIf cfg.enable {
    # https://search.nixos.org/options?channel=24.11&from=0&size=50&sort=relevance&type=packages&query=services.nginx
    networking.firewall.allowedTCPPorts = [
      # HTTP
      80
      # HTTPS
      443
    ];
    users.users.nginx.extraGroups = [ "acme" ];
    # https://nixos.wiki/wiki/Nginx
    services.nginx = {
      enable = true;
      statusPage = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts.${cfg.domain} = {
        enableACME = cfg.https;
        forceSSL = cfg.https;
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

    # Lets Encrypt
    security.acme = {
      acceptTerms = true;
      defaults.email = "theo@bionix.fyi";
    };
  };
}
