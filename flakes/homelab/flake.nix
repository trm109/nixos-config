{
  description = "Saik's personal flake containing NixOS options for homelab services";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    # deadnix: skip
    { self, nixpkgs, ... }:
    # { self, nixpkgs, ... }:
    # let
    #   supportedSystems = [
    #     "x86_64-linux"
    #     "aarch64-linux"
    #   ];
    #   forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    # in
    {
      nixosModules = {
        default = import ./default.nix;
      };

      # packages = forAllSystems (
      #   system:
      #   let
      #     pkgs = nixpkgs.legacyPackages.${system};
      #   in
      #   {
      #     # Import my custom packages.
      #     # Currently none.
      #   }
      # );
    };
}
