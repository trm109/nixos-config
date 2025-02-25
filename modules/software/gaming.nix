{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    steam-run
    protonup-qt
    mangohud
    nvtop
    (prismlauncher.override {jdks = [jdk8 jdk17 jdk21];})
    r2modman
    weston
    firejail
    zenity
    lutris
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
    gamemode = {
      enable = true;
    };
  };

  # Input Remapper
  services = {
    input-remapper = {
      enable = true;
      enableUdevRules = true;
    };
    #keyd = {
    #  enable = true;
    #};
    udev = {
      packages = with pkgs; [
        game-devices-udev-rules
      ];
    };
  };
  hardware = {
    xone.enable = true;
    xpadneo.enable = true;
    steam-hardware.enable = true;
    uinput.enable = true;
  };
}
