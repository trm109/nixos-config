{
  hostType,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.applications.graphical;
in
{
  imports = [
    ./gaming.nix
    ./productivity.nix
  ];

  options.modules.applications.graphical = {
    enable = lib.mkOption {
      default = hostType == "desktop" || false;
      description = ''
        Enable graphical applications.
      '';
    };
  };

  config = lib.mkIf (!cfg.enable) {
    modules.applications.graphical = {
      gaming.enable = false;
      productivity.enable = false;
    };
  };
}
