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
    # nixified vim setup
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Better Cursors for Hyprland
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    # Bar for Hyprland
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    # Chaotic packages
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # import ./flakes/homelab/flake.nix;
    homelab = {
      url = "path:./flakes/homelab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations =
        let
          # this is where shared configs are put
          system = "x86_64-linux"; # I only have x86 systems, so this is fine but ugly
          gamers = [
            "saik"
            "sara"
          ]; # Me and my goth gamer gf
          users = [ "saik" ]; # Default, just me
          pubKeys = {
            hosts = {
              plex-0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNNE769ehQ8NoDm/tcz/oafehsysGN0taoLfafuha0A";
              viceroy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICppn/DPe6WPH6JXAP+cIb8qsHVR6fgD6YpS11cuF4N2";
              #TODO add asus-flow
            };
            users = {
              saik = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEwHC0dPH+1iqtVZWVEJ+wLmJK17A/TzdcNGNRWrGK6";
            };
          };
          modules = [
            ./hosts
            ./modules
            ./users
            ./secrets
            inputs.agenix.nixosModules.default
            inputs.chaotic.nixosModules.default
            inputs.nix-minecraft.nixosModules.minecraft-servers
            inputs.homelab.nixosModules.default
            { }
            {
              # Default nixpkgs configs for the different channels
              nixpkgs.overlays = [
                # overlays
                # Adding pkgs.stable and pkgs.unstable to the nixpkgs overlays
                (_final: _prev: {
                  # stable nixpkgs overlay
                  stable = import inputs.nixpkgs-stable {
                    # pkgs.stable == nixpkgs-stable channel
                    inherit system;
                  };
                  # unstable nixpkgs overlay
                  unstable = import inputs.nixpkgs-unstable {
                    # pkgs.unstable == nixpkgs-unstable channel
                    inherit system;
                  };
                })
                inputs.hyprpanel.overlay
              ];
            }
            {
              # Associate the git commit revision with the system configuration
              # access with nixos-version --configuration-revision.
              system.configurationRevision = self.rev or "dirty";
            }
          ];
        in
        {
          asus-flow = nixpkgs.lib.nixosSystem {
            # Asus Flow X16 2022
            specialArgs = {
              users = gamers;
              hostname = "asus-flow"; # TODO move this to hardware-configuration.nix (??)
              hostType = "desktop"; # TODO fix spelling, all should be camelcase
              inherit inputs;
              hw = {
                # TODO, move this to hardware-configuration.nix import as a json or something. Use vendorid:productid
                formFactor = "laptop";
                gpus = [
                  {
                    type = "discrete";
                    vendor = "nvidia";
                    model = "3060";
                  }
                  {
                    type = "integrated";
                    vendor = "amd";
                    model = "680M";
                  }
                ];
                cpu = {
                  vendor = "amd";
                };
              };
              inherit pubKeys;
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
              hw = {
                formFactor = "desktop";
                gpus = [
                  {
                    type = "discrete";
                    vendor = "amd";
                    model = "7900 GRE";
                  }
                  {
                    type = "integrated";
                    vendor = "amd";
                    model = "Raphael"; # TODO find an easier way to get this. clinfo?
                  }
                ];
                cpu = {
                  vendor = "amd";
                };
              };
              inherit pubKeys;
            };
            inherit modules;
          };
          plex-0 = nixpkgs.lib.nixosSystem {
            specialArgs = {
              users = gamers;
              hostname = "plex-0";
              hostType = "server";
              inherit inputs;
              hw = {
                formFactor = "desktop";
                gpus = [
                  {
                    type = "integrated";
                    vendor = "intel";
                    model = "";
                  }
                ];
                cpu = {
                  vendor = "intel";
                };
              };
              inherit pubKeys;
            };
            inherit modules;
          };
          plex-1 = nixpkgs.lib.nixosSystem {
            specialArgs = {
              users = gamers;
              hostname = "plex-1";
              hostType = "server";
              inherit inputs;
              hw = {
                formFactor = "desktop";
                gpus = [
                  {
                    type = "integrated";
                    vendor = "intel";
                    model = "";
                  }
                ];
                cpu = {
                  vendor = "intel";
                };
              };
            };
            inherit modules;
          };
          plex-2 = nixpkgs.lib.nixosSystem {
            specialArgs = {
              users = gamers;
              hostname = "plex-2";
              hostType = "server";
              inherit inputs;
              hw = {
                formFactor = "desktop";
                gpus = [
                  {
                    type = "integrated";
                    vendor = "intel";
                    model = "";
                  }
                ];
                cpu = {
                  vendor = "intel";
                };
              };
            };
            inherit modules;
          };
          plex-3 = nixpkgs.lib.nixosSystem {
            specialArgs = {
              users = gamers;
              hostname = "plex-3";
              hostType = "server";
              inherit inputs;
              hw = {
                formFactor = "desktop";
                gpus = [
                  {
                    type = "integrated";
                    vendor = "intel";
                    model = "";
                  }
                ];
                cpu = {
                  vendor = "intel";
                };
              };
            };
            inherit modules;
          };
          #      optipleximus-prime = nixpkgs.lib.nixosSystem { # Optiplex
          #      optipleximus-prime = nixpkgs.lib.nixosSystem { # Optiplex
          #      optipleximus-prime = nixpkgs.lib.nixosSystem { # Optiplex
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
}
