{
  hw,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.firmware.gpu.nvidia;
in
{
  options.modules.firmware.gpu.nvidia = {
    enable = lib.mkOption {
      default = builtins.length (builtins.filter (gpu: gpu.vendor == "nvidia") hw.gpus) > 0 || false;
      description = "Enable Nvidia Support";
    };
    enableAcceleration = lib.mkOption {
      default = cfg.enable || false;
      description = "Enable Nvidia Acceleration";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      # dynamicBoost.enable = true; #TODO figure out if this works on AMD systems.
    };
    services.xserver.videoDrivers = lib.mkIf cfg.enable [
      "nvidia"
    ];
    nixpkgs.config.cudaSupport = cfg.enableAcceleration;
  };
}
