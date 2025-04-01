{
  lib,
  pkgs,
  config,
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
      kernelPackages = pkgs.linuxPackages_cachyos-lto;
      # crashDump.enable = true;
    };
    services = {
      scx.enable = true; # enables sched-ext
    };
    # These services don't do anything
    systemd.services = {
      mount-pstore.enable = lib.mkDefault false;
      ModemManager.enable = lib.mkDefault false;
    };
  };
}
