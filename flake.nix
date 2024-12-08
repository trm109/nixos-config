{
  description = "Saik's NixOS Flake.";

  inputs = {
    # Stable Packages
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    # Unstable Packages
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    # Hyprland
    #hyprland = {                                                          # Official Hyprland Flake
    #  url = "github:hyprwm/Hyprland";                                     # Requires "hyprland.nixosModules.default" to be added the host modules
    #  #inputs.nixpkgs.follows = "nixpkgs-unstable";
    #};
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, ags, nix-flatpak, ...} @ inputs: {
    nixosConfigurations =
      let
        system = "x86_64-linux";
        overlay-unstable = final: prev: {
          # unstable = nixpkgs-unstable.legacyPackages.${prev.system};
          # use this variant if unfree packages are needed:
          unstable = import nixpkgs-unstable {
            inherit system;
            # Allow unfree packages
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "electron-24.8.6"
                "electron-25.9.0"
              ];
            };
          };

        };
        modules = [ 
          ./.
          ({ config, pkgs, ... }: {
            nixpkgs.overlays = [
              overlay-unstable
            ];
          })
          nix-flatpak.nixosModules.nix-flatpak
        ];
      in {
#Asus Flow X16 2022
      asus-flow = nixpkgs.lib.nixosSystem {
        specialArgs = {
          users = [ "saik" "sara" ];
          hostname = "asus-flow";
          hostType = "desktop";
          inherit ags;
        };
        inherit modules;
      };
#AMD/Radeon Desktop
      viceroy = nixpkgs.lib.nixosSystem {
        specialArgs = {
          users = [ "saik" "sara" ];
          hostname = "viceroy";
          hostType = "desktop";
          inherit inputs;
        };
        inherit modules;
      };
# Optiplex
      optipleximus-prime = nixpkgs.lib.nixosSystem {
        specialArgs = {
          users = [ "saik" ];
          hostname = "optipleximus-prime";
          hostType = "server";
        };
        inherit modules;
      };
    };
  };
  
  # This allows for the gathering of prebuilt binaries, making building much faster
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://isabelroses.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "isabelroses.cachix.org-1:mXdV/CMcPDaiTmkQ7/4+MzChpOe6Cb97njKmBQQmLPM="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };
}
