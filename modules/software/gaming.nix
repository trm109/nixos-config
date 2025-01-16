{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    steam-run
    protonup-qt
    mangohud
    (prismlauncher.override {jdks = [jdk8 jdk17 jdk21];})
  ];
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      protontricks.enable = true; # Enable ProtonTricks
    };
    gamescope = {
      enable = true;
      #env = {
      #ENABLE_GAMESCOPE_WSI = "1";
      #DXVK_HDR = "1";
      #DISABLE_HDR_WSI = "1";
      #MANGOHUD = "1";
      #};
      #args = [
      #"-f"
      #"-F fsr"
      #"-h 2160"
      #"--force-grab-cursor"
      #"--adaptive-sync"
      #"--hdr-enabled"
      #"--hdr-debug-force-output"
      #"--hdr-itm-enable"
      #"--steam"
      #];
    };
  };

  # Input Remapper
  services = {
    input-remapper = {
      enable = true;
      enableUdevRules = true;
    };
  };
}
