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
  options.modules.firmware.gpu.radeon =
    let
      hasAmdGpu = builtins.length (builtins.filter (gpu: gpu.vendor == "amd") hw.gpus) > 0;
      hasDiscreteAmdGpu =
        builtins.length (builtins.filter (gpu: gpu.type == "discrete" && gpu.vendor == "amd") hw.gpus) > 0;
    in
    {
      enable = lib.mkOption {
        default = hasAmdGpu || false;
        description = "Enable AMD GPU Support";
      };
      enableAcceleration = lib.mkOption {
        default = hasDiscreteAmdGpu || false;
        description = "Enable AMD GPU Acceleration";
      };
    };

  config = lib.mkIf cfg.enable {
    hardware.amdgpu = {
      amdvlk = {
        enable = true;
        support32Bit.enable = true;
      };
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
    nixpkgs.config.rocmSupport = cfg.enableAcceleration;
  };
}
