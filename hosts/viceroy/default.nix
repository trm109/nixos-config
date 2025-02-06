{pkgs, ...}: {
  imports = [./hardware-configuration.nix];
  ## Hardware
  ### Radeon
  modules.hardware.radeon.enable = true;

  specialisation = {
    zen.configuration = {
      system.nixos.tags = ["zen"];
      boot.kernelPackages = linuxKernel.kernels.linux_zen;
    };
    xanmod.configuration = {
      system.nixos.tags = ["xanmod"];
      boot.kernelPackages = linuxKernel.kernels.linux_xanmod_latest;
    };
    cachy.configuration = {
      system.nixos.tags = ["cachy"];
      boot.kernelPackages = pkgs.linuxPackages_cachyos;
    };
  };
}
