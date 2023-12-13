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
    ];

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Hyprland
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
    xwayland.enable = true;
  };
  environment.sessionVariables = {
    # Prevents cursors from becoming invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    # Hint to election apps to use wayland
    NIXOS_OZONE_WL = "1";
  };
  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  
  # Fish
  programs.fish.enable = true;
  
  # Docker
  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "saik-nix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable Swaylock
  security.pam.services = { swaylock = { }; };
  

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Desktop Environment Related Packages
    swww
    wofi
    waybar
    mako
    wl-clipboard
    swaylock
    slurp
    grim
    libnotify
    brightnessctl
    asusctl

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
    nodejs_21
    postgresql_jit
    gh
    cmake
    clangStdenv
    zip
    unzip

# Development (GUI)
    dbeaver
    sequeler
    obs-studio
    libreoffice
    krita
    godot_4

# Tools (CLI)
    bat
    btop
    neofetch
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

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

# List services that you want to enable:

# Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # Enable Supergfxctl
  services.supergfxd.enable = true;
  # Enable asusd
  services.asusd.enable = true;
  services.asusd.enableUserService = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

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

