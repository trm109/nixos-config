{
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.applications.desktop.x11;
in
{
  imports = [
    ./i3.nix
  ];
  options.modules.applications.desktop.x11 = {
    enable = lib.mkOption {
      default = cfg.i3.enable || false;
      description = "Enable the X11 desktop applications module";
    };
  };

  config = lib.mkIf cfg.enable {
    # no clue what to put here ngl
    environment.systemPackages = with pkgs; [
      xorg.xev
    ];
  };
}
