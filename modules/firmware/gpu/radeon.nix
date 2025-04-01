{
  hw,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.firmware.gpu.radeon;
in
{
  options.modules.firmware.gpu.radeon = {
    enable = lib.mkOption {
      default = (builtins.length (builtins.filter (gpu: gpu.vendor == "radeon") hw.gpus)) > 0;
      description = "Enable Radeon Support";
    };
    enableAcceleration = lib.mkOption {
      default = cfg.enable || false;
      description = "Enable Radeon Acceleration";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = cfg.enableAcceleration;
    };

    services.xserver.videoDrivers = lib.mkIf config.modules.applications.desktop.x11.enable [
      "amdgpu"
    ];

    systemd = {
      # Add HIP support
      tmpfiles.rules = lib.mkIf cfg.enableAcceleration [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];
    };
  };
}
