# modules/network.nix
{ config, pkgs, ... }:
{
  networking.hostName = "saik-nix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  networking.firewall.checkReversePath = false;

  # Enable NAT
  # networking.nat = { enable = true;
  #   internalInterfaces = [ "enp0s3" ];
  #   externalInterface = "wlp7s0";
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  # add packages.
  environment.systemPackages = with pkgs; [
    protonvpn-cli
    # Plugins
    networkmanagerapplet
    networkmanager-openvpn
  ];
}
