{lib, ...}: {
  imports = [./hardware-configuration.nix];

  modules = {
    # Hardware
    hardware = {
      # Asus Specific
      asus.enable = true;
      # Nvidia (CONDITIONAL, specialisation based)
      nvidia.enable = lib.mkDefault true;
      # Printers
      printers.enable = true;
      # Battery management
      battery.enable = true;
    };
  };

  specialisation = {
    # Low power, high efficiency
    efficience.configuration = {
      system.nixos.tags = ["efficience"];
      modules.hardware.nvidia.enable = false;
    };
  };
}
