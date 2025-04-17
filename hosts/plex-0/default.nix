{ lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  modules.services.homelab = {
    enable = true;
    teslamate.enable = false;
  };
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
