{
  lib,
  config,
  hostname,
  pkgs,
  ...
}:
let
  cfg = config.modules.services.network;
in
{
  options.modules.services.network = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the network module";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      networkmanagerapplet # TODO if a graphical session is present
      openfortivpn # fortissl vpn client
      #tailscale # tailscale client
      ktailctl
    ];
    # Network
    networking = {
      hostName = "${hostname}";
      firewall = {
        enable = true;
      };
      networkmanager.enable = true;
      nameservers = [
        # TODO use tailscale's config
        "8.8.8.8"
        "8.8.4.4"
        "1.1.1.1"
        "1.0.0.1"
      ];
    };

    services = {
      fail2ban = {
        enable = lib.mkDefault true;
        ignoreIP = [
          "192.168.0.0/16" # local network
          "127.0.0.0/8" # localhost
        ];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
      };
      tailscale = {
        # TODO add automatic Agenix certs.
        # TODO add auto-start
        # TODO add AdGuardHome as DNS
        enable = true;
        useRoutingFeatures = "both";
        authKeyFile = config.age.secrets.tailscale_auth_key.path;
      };
    };
    # Reduces startup time
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
