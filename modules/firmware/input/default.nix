{ lib, ... }:
let
  cfg = config.modules.firmware.input;
in
{
  imports = [
    ./gamepad.nix
  ];
  options.modules.firmware.input = {
    enable = lib.mkOption {
      default = true;
      description = "Enable firmware input settings";
    };
  };

  config = mkIf (!cfg.enable) {
    modules.firmware.input = {
      gamepad.enable = false;
    };
  };
}
