# flake.nix

{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true; 
        };
      };
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs system;};
          modules = [ 
            ./hosts/default/configuration.nix
            ./users/saik.nix
            inputs.home-manager.nixosModules.default
          ];
        };
      };
    };
}
