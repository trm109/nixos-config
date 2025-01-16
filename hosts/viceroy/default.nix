{...}: {
  imports = [./hardware-configuration.nix];
  ## Hardware
  ### Radeon
  modules.hardware.radeon.enable = true;
}
