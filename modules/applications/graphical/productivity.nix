{
  lib,
  config,
  hostType,
  ...
}:
let
  cfg = config.modules.applications.graphical.productivity;
in
{
  options.modules.applications.graphical.productivity = {
    enable = lib.mkOption {
      default = hostType == "desktop" || false;
      description = ''
        Enable graphical, productivity applications.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      obs-studio = {
        enable = true;
        enableVirtualCamera = true;
      };
    };
    services = {
      gvfs = {
        enable = true;
      };
      tumbler = {
        enable = true;
      };
    };
  };
}
