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
    # https://www.reddit.com/r/ROCm/comments/1g3lnuj/rocm_apu_680m_and_gtt_memory_on_arch/
    #hardware.amdgpu = {
    #  initrd.enable = true;
    #  opencl.enable = cfg.enableAcceleration;
    #};
    boot.kernelParams = [
      "iommu=pt"
    ];
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa
          libva
          libvdpau-va-gl
          vulkan-loader
          vulkan-validation-layers
          amdvlk
          #mesa.opencl
        ];
      };
      amdgpu.overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff"; # Enable Overdrive
      };
    };
    # Use RADV as the default Vulkan driver
    environment.variables.AMD_VULKAN_ICD = "RADV";
    #
    boot.initrd.kernelModules = [
      "amdgpu"
    ];
    #
    services.xserver.videoDrivers = [
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
