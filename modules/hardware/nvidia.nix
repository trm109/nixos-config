{ lib, config, pkgs, ... }:
let 
  cfg = config.modules.hardware.nvidia;
in
{
  options.modules.hardware.nvidia = {
    enable = lib.mkEnableOption "Enable Nvidia Support";
  };

  config = lib.mkIf cfg.enable {
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    # enable x server drivers
    services.xserver.videoDrivers = [ "amdgpu" "nvidia"];
    # Enable kernel and drivers
    hardware.nvidia = {

      modesetting.enable = true;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
    # for specific app gpu control
    services.switcherooControl.enable = true;
  };
} 
