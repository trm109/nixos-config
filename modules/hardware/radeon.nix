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
    hardware = {
      opengl = {
        extraPackages = with pkgs; [
          rocmPackages.clr.icd
        ];
      };
      graphics = {
        enable = true;
        #driSupport = true;
        enable32Bit = true;
      };
    };
    environment.systemPackages = with pkgs; [
      #rocmPackages.hip
      clinfo
      lact
    ];
    services = {
      switcherooControl.enable = true;
      xserver.videoDrivers = ["amdgpu"];
    };

    systemd = {
      # Add HIP support
      tmpfiles.rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
      ];
      services.lactd = {
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
  };
}
