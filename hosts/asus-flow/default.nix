{ lib, config, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  ## Hardware
  ### Asus Specific
  modules.hardware.asus.enable = true;
  ### Nvidia (CONDITIONAL, specialisation based)
  modules.hardware.nvidia.enable = lib.mkDefault true;
  ### Printers
  modules.hardware.printers.enable = true;

  specialisation = {
    # Low power, high efficiency
    efficience.configuration = {
      system.nixos.tags = [ "efficience" ];
      modules.hardware.nvidia.enable = false;
    };
  };
}
