{
  lib,
  pkgs,
  config,
  hostType,
  ...
}:
let
  cfg = config.modules.system.kernel;
in
{
  options.modules.system.kernel = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the kernel module";
    };
  };
  config = lib.mkIf cfg.enable {
    boot = {
      kernelPackages = if hostType == "desktop" then pkgs.linuxPackages_cachyos-lto else pkgs.linuxKernel.packages.linux_6_14;
      # crashDump.enable = true;
    };
    services = {
      scx.enable = if hostType == "desktop" then true else false; # enables sched-ext
    };
    # These services don't do anything
    systemd.services = {
      mount-pstore.enable = lib.mkDefault false;
      ModemManager.enable = lib.mkDefault false;
    };
  };
}
