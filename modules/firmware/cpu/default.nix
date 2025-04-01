{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.firmware.cpu;
in
{
  imports = [
    ./amd.nix
  ];
  options.modules.firmware.cpu = {
    enable = lib.mkOption {
      default = true;
      description = "Enable default CPU firmware";
    };
  };
  config = lib.mkIf (!cfg.enable) {
    modules.firmware.cpu = {
      amd.enable = false;
    };
  };
}
