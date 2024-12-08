{ lib, config, ... }:
let
  cfg = config.modules.hardware.radeon;
in
{
  options.modules.hardware.radeon = {
    enable = lib.mkEnableOption "Enable Radeon Support";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = [ "amdgpu" ];
    services.xserver.videoDrivers = [ "amdgpu" ];
    
    hardware.graphics = {
      enable = true;
      #driSupport = true;
      enable32Bit = true;
    };

    services.switcherooControl.enable = true;
  };
}
