{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    protonup-qt
    mangohud
    gamemode
  ];
  programs.steam = {
    enable = true;
    package = pkgs.unstable.steam;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
# Input Remapper 
  services.input-remapper.enable = true;
  services.input-remapper.package = pkgs.unstable.input-remapper;
}
