# WIP TODO: reimplement https://github.com/adam900710/simple-kdump/tree/main
{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.services.crash-kernel;
in
{
  options = {
    services.crash-kernel.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable crash kernel support.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelParams = [
      "crashkernel=512M"
      "nmi_watchdog=panic"
      "softlockup_panic=1"
    ];
  };
}
