{ config, ... }:
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
  networking.firewall.allowedTCPPorts = [
    80 # HTTP
    443 # HTTPS
  ];
  services = {
    grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          #enforce_domain = true;
          enable_gzip = true;
          #domain = "grafana.${config.networking.hostName}.local";
          # Alternatively, if you want to server Grafana from a subpath:
          domain = "${config.networking.hostName}";
          root_url = "${config.services.grafana.settings.server.protocol}://${config.networking.hostName}/grafana";
          serve_from_sub_path = true;
        };

        # Prevents Grafana from phoning home
        analytics.reporting_enabled = false;
      };
    };

    nginx = {
      enable = true;
      virtualHosts.${config.services.grafana.domain} = {
        locations."/grafana" = {
          proxyPass = "${config.services.grafana.settings.server.protocol}://${config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
          proxyWebsockets = true;
        };
      };
    };
  };
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
