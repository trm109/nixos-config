# users/saik.nix

{ config, lib, pkgs, ... }:

{
  users.users.saik = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "docker" ];
    shell = pkgs.fish;
  };

}
