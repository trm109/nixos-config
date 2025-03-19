{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    steam-run
    protonup-qt
    mangohud
    nvtopPackages.full
    (prismlauncher.override {jdks = [jdk8 jdk17 jdk21];})
    #(gale.overrideAttrs (old: {
    #  src = pkgs.fetchFromGitHub {
    #    owner = "Kesomannen";
    #    repo = "gale";
    #    rev = "52e9b4bce0001d6558d87a547a2cc37beb18700d";
    #    hash = "sha256-t/N4u23ycCZtkQbIZToxCaD0FVrOQdWDIwUjGtX2yqk=";
    #  };
    #  npmDeps = pkgs.fetchNpmDeps {
    #    name = "gale-1.4.3-npm-deps";
    #    src = pkgs.fetchFromGitHub {
    #      owner = "Kesomannen";
    #      repo = "gale";
    #      rev = "52e9b4bce0001d6558d87a547a2cc37beb18700d";
    #      hash = "sha256-t/N4u23ycCZtkQbIZToxCaD0FVrOQdWDIwUjGtX2yqk=";
    #    };
    #    hash = "sha256-/+NhlQydGS6+2jEjpbwycwKplVo/++wcdPiBNY3R3FI=";
    #  };
    #  cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
    #    pname = "gale";
    #    version = "1.4.3";
    #    src = pkgs.fetchFromGitHub {
    #      owner = "Kesomannen";
    #      repo = "gale";
    #      rev = "52e9b4bce0001d6558d87a547a2cc37beb18700d";
    #      hash = "sha256-t/N4u23ycCZtkQbIZToxCaD0FVrOQdWDIwUjGtX2yqk=";
    #    };
    #    cargoRoot = "src-tauri";
    #    hash = "sha256-RceQ9Zc1yMTXSZ84wTPP51F/N+F6294JixBYjCgCY/0=";
    #  };
    #}))
    (r2modman.overrideAttrs (
      let
        src = pkgs.fetchFromGitHub {
          owner = "ebkr";
          repo = "r2modmanPlus";
          rev = "59c1fe5287593eb58b4ce6d5d8f2ca59ca64bfd4";
          hash = "sha256-1b24tclqXGx85BGFYL9cbthLScVWau2OmRh9YElfCLs=";
        };
      in {
        inherit src;
        offlineCache = pkgs.fetchYarnDeps {
          yarnLock = "${src}/yarn.lock";
          hash = "sha256-3SMvUx+TwUmOur/50HDLWt0EayY5tst4YANWIlXdiPQ=";
        };
      }
    ))
    weston
    firejail
    zenity
    lutris
    goverlay
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
    #xone.enable = true;
    xpadneo.enable = true;
    steam-hardware.enable = true;
    uinput.enable = true;
  };
}
