{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.firmware.input;
in
{
  imports = [
    ./gamepad.nix
    ./qmk.nix
  ];
  options.modules.firmware.input = {
    enable = lib.mkOption {
      default = true;
      description = "Enable firmware input settings";
    };
  };

  config = lib.mkIf (!cfg.enable) {
    modules.firmware.input = {
      gamepad.enable = false;
      qmk.enable = false;
    };
  };
}
