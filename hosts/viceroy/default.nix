{ ... }:
{
  imports = [ ./hardware-configuration.nix ];
  ## Hardware
  ### Radeon
  #modules = {
  #  hardware = {
  #    radeon.enable = true;
  #    razer.enable = false;
  #  };
  #};
  modules = {
    applications = {
      desktop.wayland.hyprland.enable = true;
      graphical = {
        gaming.enable = true;
      };
    };
  };
  #hardware.keyboard.qmk.enable = true;
  #specialisation = {
  #  zen.configuration = {
  #    system.nixos.tags = ["zen"];
  #    boot.kernelPackages = pkgs.linuxPackages_zen;
  #  };
  #  xanmod.configuration = {
  #    system.nixos.tags = ["xanmod"];
  #    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
  #  };
  #  cachy.configuration = {
  #    system.nixos.tags = ["cachy"];
  #    boot.kernelPackages = pkgs.linuxPackages_cachyos;
  #  };
  #};
}
