{
  pkgs,
  lib ? pkgs.lib,
  config ? pkgs.lib.nixosConfiguration,
  ...
}:
let
  cfg = config.homelab;
in
{

  imports = [
    ./kubernetes.nix
  ];

  options.homelab = {
    enable = lib.mkEnableOption "Enable default Homelab configuration";
  };

  config = lib.mkIf cfg.enable {
  };
}
