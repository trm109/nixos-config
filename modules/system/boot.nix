_: {
  # Support wack-ass windows filesystem
  boot = {
    supportedFilesystems = ["ntfs"];
    loader.grub.configurationLimit = 4;
    #extraModulePackages = with config.boot.kernelPackages; [ xpadneo ];
    extraModprobeConfig = ''
      options bluetooth disable_ertm=Y
    '';
    initrd.kernelModules = ["xpad" "joydev" "usbhid"];
    # connect xbox controller
  };

  # Enable crashDump
  #boot.crashDump.enable = true;
}
