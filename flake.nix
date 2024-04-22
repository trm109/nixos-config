{
  description = "Saik's NixOS Flake.";

  inputs = {
    # Stable Packages
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.11";
    };
    # Unstable Packages
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags = {
      url = "github:Aylur/ags";
    };
    # Hyprland
    #hyprland = {                                                          # Official Hyprland Flake
    #  url = "github:hyprwm/Hyprland";                                     # Requires "hyprland.nixosModules.default" to be added the host modules
    #  #inputs.nixpkgs.follows = "nixpkgs-unstable";
    #};
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, ags, ...} @ inputs: {
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
          (
            { config, pkgs, ... }: {
              nixpkgs.overlays = [
                overlay-unstable
              ];
            }
          )
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
}
