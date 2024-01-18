# config, pkgs
{ config, pkgs, ... }:

{
  # Enable virtualization
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #virtualisation.libvirtd.enable = true;
  #programs.virt-manager.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.virtualbox.guest.enable = true;
  nixpkgs.config.virtualbox.enableExtensionPack = true;
}
