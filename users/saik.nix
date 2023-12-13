# users/saik.nix

{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "saik" = import ../hosts/default/home.nix;
    };
  };

  users.users.saik = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "docker" ];
    shell = pkgs.fish;
  };

}
