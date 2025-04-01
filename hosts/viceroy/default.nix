{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];
  ## Hardware
  ### Radeon
  modules = {
    hardware = {
      radeon.enable = true;
      razer.enable = false;
    };
  };
  #hardware.keyboard.qmk.enable = true;
  #Vid: 0x3434
  #Pid: 0x02A0
  services.udev.extraRules = ''
    SUBSYSTEMS=="usb", ATTRSV{idVendor}=="3434", ATTRS{idProduct=="02A0", TAG+="uaccess"
  '';
  environment.systemPackages = with pkgs; [
    via
  ];
  services.udev.packages = [ pkgs.via ];

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
