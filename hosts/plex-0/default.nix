{ lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  modules.services = {
    #gameserver.minecraft.enable = true;
    homelab = {
      #enable = true;
      #teslamate.enable = lib.mkForce false;
      adguardhome.enable = true;
      focalboard.enable = true;
      #kubernetes = {
      #  enable = true;
      #  isMaster = true;
      #  #masterHostname = config.networking.hostName;
      #  #masterHostname = "100.69.238.57";
      #  masterHostname = "192.168.50.3";
      #};
    };
  };
  homelab = {
    kubernetes = {
      enable = true;
      asMaster = true;
      masterHostname = "plex-0";
      masterIP = "192.168.50.3";
    };
  };
  #services.k3s.clusterInit = true;

  networking.firewall = {
    allowedTCPPorts = [
      42420 # Vintage Story
    ];
  };
  services.fail2ban.enable = lib.mkForce false;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05"; # Did you read the comment?
}
