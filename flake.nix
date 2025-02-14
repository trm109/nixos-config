{
  description = "Saik's NixOS Flake.";

  inputs = {
    # Default Package Channel
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    # Unstable Package Channel
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    # Stable Package Channel
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
    # Home-Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Flatpak functionality for NixOS
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # Better Cursors for Hyprland
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    # Bar for Hyprland
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    # Chaotic packages
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-stable,
    nix-flatpak,
    home-manager,
    chaotic,
    ...
  } @ inputs: {
    nixosConfigurations = let
      # this is where shared configs are put
      system = "x86_64-linux"; # I only have x86 systems, so this is fine but ugly
      gamers = [
        "saik"
        "sara"
      ]; # Me and my goth gamer gf
      users = ["saik"]; # Default, just me
      modules = [
        ./. # import /etc/nixos/default.nix
        {
          # Default nixpkgs configs for the different channels
          nixpkgs.overlays = let
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                # TODO determine if I still need these enabled
                "electron-24.8.6"
                "electron-25.9.0"
                "dotnet-sdk-6.0.428"
              ];
            };
          in [
            (_final: _prev: {
              # stable nixpkgs overlay
              stable = import nixpkgs-stable {
                # pkgs.stable == nixpkgs-stable channel
                inherit system;
                inherit config;
              };
            })
            (_final: _prev: {
              # unstable nixpkgs overlay
              unstable = import nixpkgs-unstable {
                # pkgs.unstable == nixpkgs-unstable channel
                inherit system;
                inherit config;
              };
            })
            inputs.hyprpanel.overlay
          ];
        }
        nix-flatpak.nixosModules.nix-flatpak
        home-manager.nixosModules.home-manager
        chaotic.homeManagerModules.default
        {
          home-manager = {
            useUserPackages = true;
            useGlobalPkgs = true;
            extraSpecialArgs = {inherit inputs;};
          };
        }
      ];
    in {
      asus-flow = nixpkgs.lib.nixosSystem {
        # Asus Flow X16 2022
        specialArgs = {
          users = gamers;
          hostname = "asus-flow";
          hostType = "desktop";
          inherit inputs;
        };
        inherit modules;
      };
      viceroy = nixpkgs.lib.nixosSystem {
        # AMD/Radeon Desktop
        specialArgs = {
          users = gamers;
          hostname = "viceroy";
          hostType = "desktop";
          inherit inputs;
        };
        inherit modules;
      };
      #      optipleximus-prime = nixpkgs.lib.nixosSystem { # Optiplex
      #        specialArgs = {
      #          inherit users;
      #          hostname = "optipleximus-prime";
      #          hostType = "server";
      #        };
      #        inherit modules;
      #      };
      #    };
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
