# Settings to enable gamepad support
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.firmware.input.gamepad;
in
{
  options.modules.firmware.input.gamepad = {
    enable = lib.mkOption {
      default = config.modules.applications.graphical.gaming.enable || false;
      description = "Enable gamepad support";
    };
  };
  config = lib.mkIf cfg.enable {
    services = {
      udev = {
        # gamepad support
        packages = with pkgs; [
          game-devices-udev-rules
        ];
      };
    };

    # TODO test how much of this is necessary
    hardware = {
      #xone.enable = true;
      #xpadneo.enable = true;
      steam-hardware.enable = true;
      uinput.enable = true;
    };
  };
}
