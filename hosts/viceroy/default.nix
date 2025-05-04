{ ... }:
{
  imports = [ ./hardware-configuration.nix ];
  ## Hardware
  ### Radeon
  #modules = {
  #  hardware = {
  #    radeon.enable = true;
  #    razer.enable = false;
  #  };
  #};
  modules = {
    applications = {
      desktop.wayland.hyprland.enable = true;
      graphical = {
        gaming.enable = true;
      };
    };
  };
  hardware = {
    xpadneo.enable = false;
    xone.enable = false;
  };
  # https://github.com/ahbk/my-nixos/blob/c0c8c2cccd72b5c688154483d1e8e261e26f57b4/modules/collabora.nix#L33
  #security.acme = {
  #  acceptTerms = true;
  #  certs = {
  #    "grafana.${config.networking.hostName}.io".email = "theo@bionix.fyi";
  #  };
  #};
  #networking.firewall.allowedTCPPorts = [
  #  #80 # HTTP
  #  #443 # HTTPS
  #  config.services.nginx.defaultHTTPListenPort
  #  config.services.nginx.defaultSSLListenPort
  #];
  #services = {
  #  grafana = {
  #    enable = true;
  #    settings = {
  #      server = {
  #        http_addr = "127.0.0.1";
  #        http_port = 3000;
  #        enable_gzip = true;
  #        #domain = "grafana.${config.networking.hostName}.local";
  #        # Alternatively, if you want to server Grafana from a subpath:
  #        domain = "grafana.${config.networking.hostName}";
  #        root_url = "${config.services.grafana.settings.server.protocol}://${config.services.grafana.settings.server.domain}";
  #        serve_from_sub_path = true;
  #      };

  #      # Prevents Grafana from phoning home
  #      analytics.reporting_enabled = false;
  #    };
  #  };

  #  #nginx = {
  #  #  virtualHosts."grafana.${config.services.grafana.settings.server.domain}" = {
  #  #    forceSSL = true;
  #  #    enableACME = true;
  #  #    locations."/" = {
  #  #      proxyPass = "${config.services.grafana.settings.server.protocol}://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
  #  #      proxyWebsockets = true;
  #  #      recommendedProxySettings = true;
  #  #    };
  #  #  };
  #  #};
  #};
  #hardware.keyboard.qmk.enable = true;
  #specialisation = {
  #  zen.configuration = {
  #    system.nixos.tags = ["zen"];
  #    boot.kernelPackages = pkgs.linuxPackages_zen;
  #  };
  #  xanmod.configuration = {
  #    system.nixos.tags = ["xanmod"];
  #    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  #  };
  #  cachy.configuration = {
  #    system.nixos.tags = ["cachy"];
  #    boot.kernelPackages = pkgs.linuxPackages_cachyos;
  #  };
  #};
}
