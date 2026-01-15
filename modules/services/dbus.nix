{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.services.dbus;
in
{
  options.modules.services.dbus = {
    enable = lib.mkOption {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    services.dbus = {
      implementation = "broker";
    };
  };
}
