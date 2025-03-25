{
  lib,
  pkgs,
  ...
}: {
  boot = {
    # Support wack-ass windows filesystem
    supportedFilesystems = ["ntfs"];
    loader.grub.configurationLimit = 4;
    #extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    '';
    # connect xbox controller
    initrd.kernelModules = ["xpad" "joydev" "usbhid"];
    # Using cachy kernel
    kernelPackages = pkgs.linuxPackages_cachyos-lto;
  };
  services = {
    scx.enable = true; # enables sched-ext
  };
  systemd.services = {
    mount-pstore.enable = lib.mkDefault false;
    ModemManager.enable = lib.mkDefault false;
  };

  # Enable crashDump
  #boot.crashDump.enable = true;
}
