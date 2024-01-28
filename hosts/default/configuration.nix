# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/cups.nix # Enable Printing
      ../../modules/audio.nix # Enable Audio
      ../../modules/bluetooth.nix # Enable Bluetooth
      ../../modules/hyprland.nix # Enable Hyprland
      ../../modules/network.nix # Enable Networking
      ../../modules/asus.nix # Enable Asus Specifics
      ../../modules/virtualisation.nix # Enable virtualisation
    ];


  # Enable steam
  programs.steam.enable = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Fish
  programs.fish.enable = true;
  
  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-19.1.9"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [


    # Desktop Apps
    discord
    chromium
    kitty
    firefox
    mpv-unwrapped
    spotify
    zoom-us
    xfce.thunar
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
    pavucontrol
    microsoft-edge
    (prismlauncher.override { jdks = [ jdk8 jdk17]; })
    stremio
    speedcrunch
    inkscape-with-extensions
    pstoedit
    ghostscript
    etcher

    #virtualbox
    #virtualboxWithExtpack

    # Development (CLI)
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    tree
    wget
    fish
    docker-compose
    llvm_12
    jdk21
    jdk17
    nodejs_21
    postgresql_jit
    gh
    cmake
    clangStdenv
    zip
    unzip
    awscli2
    nodePackages.aws-cdk
    android-tools
    python3
    rustup
    gcc
    gvfs
    R
    rPackages.devtools
    rPackages.Seurat
    rPackages.sctransform
    rPackages.dplyr

# Development (GUI)
    #dbeaver
    #sequeler
    #obs-studio
    libreoffice
    krita
    godot_4
    ventoy-full

# Tools (CLI)
    bat
    btop
    neofetch
    hyprpicker
    libclang
    stylua
    deno
    libgcc
    cordless
    jq

# Gaming
    mangohud
    gamemode
    keymapper
  ];
  

  nixpkgs.overlays = [
    (self: super:
     {
     zoomUsFixed = pkgs.zoom-us.overrideAttrs (old: {
         postFixup = old.postFixup + ''
         wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
         '';});
     zoom = pkgs.zoom-us.overrideAttrs (old: {
         postFixup = old.postFixup + ''
         wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE
         '';});
     }
    )
  ];
# Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ 
      comic-mono
      (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
      (google-fonts.override { fonts = ["NoticiaText" "PatrickHand"]; })
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "Comic Mono" "FiraCode" "DroidSansMono" ];
      };
    };
  };



  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}

