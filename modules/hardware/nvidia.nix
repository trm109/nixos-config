{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.hardware.nvidia;
in {
  options.modules.hardware.nvidia = {
    enable = lib.mkEnableOption "Enable Nvidia Support";
  };

  config = lib.mkIf cfg.enable {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    # enable x server drivers
    services.xserver.videoDrivers = ["amdgpu" "nvidia"];
    # Enable kernel and drivers
    hardware.nvidia = {
      modesetting.enable = true;

      nvidiaSettings = true;
      open = true;

      package = config.boot.kernelPackages.nvidiaPackages.production;
    };
    # for specific app gpu control
    services.switcherooControl = {
      enable = true;
      package = pkgs.switcheroo-control.overrideAttrs (oldAttrs: {
        nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.wrapGAppsNoGuiHook];
      });
    };
  };
}
