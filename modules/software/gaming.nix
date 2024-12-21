{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    protonup-qt
    mangohud
    gamemode


    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ ffmpeg ];
      # Change Java runtimes available to Prism Launcher
      jdks = [
        graalvm-ce
        zulu8
        zulu17
        zulu23
        temurin-bin-21
        jdk21_headless
        zulu
      ];
    })
  ];
  programs.steam = {
    enable = true;
    package = pkgs.unstable.steam;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
# Input Remapper 
  services.input-remapper = {
    enable = true;
    enableUdevRules = true;
  };
}
