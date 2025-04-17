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
    ];
    # Network
    networking = {
      hostName = "${hostname}";
      firewall = {
        enable = true;
      };
      networkmanager.enable = true;
      nameservers = [
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
    };
    # Reduces startup time
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
