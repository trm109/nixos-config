{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.hardware.radeon;
in {
  options.modules.hardware.radeon = {
    enable = lib.mkEnableOption "Enable Radeon Support";
  };

  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = ["amdgpu"];
    services.xserver.videoDrivers = ["amdgpu"];

    hardware.graphics = {
      enable = true;
      #driSupport = true;
      enable32Bit = true;
    };
    # Add HIP support
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
    services.switcherooControl.enable = true;
    systemd.services.lactd = {
      enable = true;
      description = "Radeon GPU monitor";
      after = [
        "syslog.target"
        "systemd-modules-load.service"
      ];

      unitConfig = {
        ConditionPathExists = "${pkgs.lact}/bin/lact";
      };

      serviceConfig = {
        User = "root";
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };

      wantedBy = ["multi-user.target"];
    };
  };
}
