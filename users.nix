{ lib, config, pkgs, ... }:

{
  users.users.saik2 = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  }
}
