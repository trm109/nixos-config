{
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  modules = {
    applications = {
      desktop.wayland.hyprland.enable = true;
      graphical.gaming.enable = true;
    };
    firmware = {
      asus.enable = true;
      gpu.nvidia.enable = false;
    };
    # Hardware
    #hardware = {
    #  # Asus Specific
    #  asus.enable = true;
    #  # Nvidia (CONDITIONAL, specialisation based)
    #  nvidia.enable = lib.mkDefault true;
    #  # Printers
    #  printers.enable = true;
    #  # Battery management
    #  battery.enable = true;
    #  razer.enable = false;
    #};
  };

  boot = {
    crashDump = {
      enable = true;
      reservedMemory = "512M";
    };
    #kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_6_14;
    # Things to disable NVIDIA
    blacklistedKernelModules = [
      "nouveau"
      "nvidia"
      "nvidia_drm"
      "nvidia_modeset"
    ];
    extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';
  };
  services.udev.extraRules = ''
    # Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

    # Remove NVIDIA USB Type-C UCSI devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

    # Remove NVIDIA Audio devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

    # Remove NVIDIA VGA/3D controller devices
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  '';

  #specialisation = {
  #  # Low power, high efficiency
  #  efficience.configuration = {
  #    system.nixos.tags = [ "efficience" ];
  #    modules.firmware.gpu.nvidia.enable = false;
  #    boot.extraModprobeConfig = ''
  #      blacklist nouveau
  #      options nouveau modeset=0
  #    '';

  #    services.udev.extraRules = ''
  #      # Remove NVIDIA USB xHCI Host Controller devices, if present
  #      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

  #      # Remove NVIDIA USB Type-C UCSI devices, if present
  #      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

  #      # Remove NVIDIA Audio devices, if present
  #      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

  #      # Remove NVIDIA VGA/3D controller devices
  #      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  #    '';
  #    boot.blacklistedKernelModules = [
  #      "nouveau"
  #      "nvidia"
  #      "nvidia_drm"
  #      "nvidia_modeset"
  #    ];
  #  };
  #};
}
