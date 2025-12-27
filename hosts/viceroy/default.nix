{ lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  ## Hardware
  modules = {
    applications = {
      desktop.wayland.hyprland.enable = true;
      graphical = {
        gaming.enable = true;
      };
    };
    system.nix.hostBuilder.enable = true;
    firmware = {
      gpu.radeon.enable = true;
      cpu.amd.enable = true;
    };
    services = {
      keyd.enable = true;
    };
  };
  services.udev.packages = [ pkgs.android-udev-rules ];
  #homelab.kubernetes = {
  #  enable = true;
  #  masterIP = "192.168.50.3";
  #  masterHostname = "plex-0";
  #  apitokenPath = config.age.secrets.kubernetes-apitoken.path;
  #};
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
  networking.firewall.enable = lib.mkForce false;
}
