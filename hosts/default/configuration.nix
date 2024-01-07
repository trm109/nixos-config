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
    ];

  # Enable virtualization
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.guest.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

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
    pavucontrol
    microsoft-edge
    (prismlauncher.override { jdks = [ jdk8 jdk17]; })
    stremio
    #virtualbox
    #virtualboxWithExtpack

    # Development (CLI)
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    neovim
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

# Development (GUI)
    dbeaver
    sequeler
    obs-studio
    libreoffice
    krita
    godot_4
    unetbootin
    protonvpn-gui

# Tools (CLI)
    bat
    btop
    neofetch


# Gaming
    steam
    mangohud
    gamemode
    protonup-qt
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

