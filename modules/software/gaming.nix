{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    protonup-qt
    mangohud
    gamemode
  ];
  # Input Remapper 
  services.input-remapper.enable = true;
  services.input-remapper.package = pkgs.unstable.input-remapper;
}
