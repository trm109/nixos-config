{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.services.ssh;
in
{
  options.modules.services.ssh = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the SSH service.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
    };
  };
}
