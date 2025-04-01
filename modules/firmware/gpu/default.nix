{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.firmware.gpu;
in
{
  imports = [
    ./nvidia.nix
    ./radeon.nix
  ];

  options.modules.firmware.gpu = {
    enable = lib.mkOption {
      default = true;
      description = ''
        Enable the firmware for the GPU.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    environment.systemPackages = with pkgs; [
      clinfo
      lact
    ];

    services = {
      switcherooControl = {
        enable = true;
        #package = pkgs.switcheroo-control.overrideAttrs (oldAttrs: {
        #  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [pkgs.wrapGAppsNoGuiHook];
        #});
      };
    };

    systemd.services.lactd = {
      enable = true;
      description = " Linux GPU Configuration Daemon";
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

      wantedBy = [ "multi-user.target" ];
    };
  };
}
