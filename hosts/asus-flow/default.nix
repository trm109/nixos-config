{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  modules = {
    applications = {
      desktop.wayland.hyprland.enable = true;
      graphical.gaming.enable = true;
    };
    firmware = {
      asus.enable = true;
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

  specialisation = {
    # Low power, high efficiency
    efficience.configuration = {
      system.nixos.tags = [ "efficience" ];
      modules.firmware.gpu.nvidia.enable = false;
    };
  };
}
