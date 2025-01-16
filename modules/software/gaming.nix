{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    protonup-qt
    mangohud
    gamemode
    (prismlauncher.override { jdks = [ jdk8 jdk17 jdk21 ]; })
    gamescope-wsi
    steamtinkerlaunch
    yad # A dependency of stl
    xdotool
    xorg.xprop
    xorg.xrandr
    unixtools.xxd
    xorg.xwininfo
    usbutils
  ];
  programs.steam = {
    enable = true;
    package = pkgs.steam;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    protontricks.enable = true; # Enable ProtonTricks
  };
  programs.gamescope = {
    package = pkgs.gamescope-wsi;
    /*env = {
      ENABLE_GAMESCOPE_WSI = "1";
      DXVK_HDR = "1";
      DISABLE_HDR_WSI = "1";
      MANGOHUD = "1";
    };
    args = [
      "-f"
      "-F fsr"
      "-h 2160"
      "--force-grab-cursor"
      "--adaptive-sync"
      "--hdr-enabled"
      "--hdr-debug-force-output"
      "--hdr-itm-enable"
      "--steam"
    ];*/
  };

  nixpkgs.overlays = [
    (final: prev: {
      gamescope-wsi = prev.gamescope-wsi.override { enableExecutable = true; };
    })
  ];
# Input Remapper 
  services.input-remapper = {
    enable = true;
    enableUdevRules = true;
  };
}
