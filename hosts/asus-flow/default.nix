{
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  modules = {
    applications = {
      desktop.wayland.hyprland.enable = true;
      graphical = {
        gaming.enable = true;
        productivity.enable = true;
      };
    };

    firmware = {
      asus.enable = true;
      gpu.nvidia.enable = true;
    };
  };
  environment.sessionVariables = {
    AQ_DRM_DEVICES = "/dev/dri/card1";
    WLR_DRM_DEVICES = "/dev/dri/card1";
  };
  hardware = {
    nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      #0a:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Rembrandt [Radeon 680M] (rev c8)
      amdgpuBusId = "PCI:10:00:0";
      #01:00.0 VGA compatible controller: NVIDIA Corporation GA106M [GeForce RTX 3060 Mobile / Max-Q] (rev a1)
      nvidiaBusId = "PCI:01:00:0";
    };
  };
  # https://github.com/ahbk/my-nixos/blob/c0c8c2cccd72b5c688154483d1e8e261e26f57b4/modules/collabora.nix#L33
  #security.acme = {

  #boot = {
  #  #crashDump = {
  #  #  enable = true;
  #  #  reservedMemory = "512M";
  #  #};
  #  #kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_6_14;
  #  # Things to disable NVIDIA
  #  blacklistedKernelModules = [
  #    "nouveau"
  #    "nvidia"
  #    "nvidia_drm"
  #    "nvidia_modeset"
  #  ];
  #  extraModprobeConfig = ''
  #    blacklist nouveau
  #    options nouveau modeset=0
  #  '';
  #};
  #services.udev.extraRules = ''
  #  # Remove NVIDIA USB xHCI Host Controller devices, if present
  #  ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

  #  # Remove NVIDIA USB Type-C UCSI devices, if present
  #  ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

  #  # Remove NVIDIA Audio devices, if present
  #  ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

  #  # Remove NVIDIA VGA/3D controller devices
  #  ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
  #'';

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
