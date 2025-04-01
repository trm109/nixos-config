# AI related background services
# Eventually, would be nice to make these Daemon-less
{
  lib,
  pkgs,
  config,
  hostType,
  hw,
  ...
}:
let
  cfg = config.modules.services.ai;
in
{
  options.modules.services.ai = {
    enable = lib.mkOption {
      # if hostType is desktop, and user has a hw.gpus.*.type = "discrete"
      default = hostType == "desktop" && builtins.any (gpu: gpu.type == "discrete") hw.gpus || false;
      #default = false;
      description = "Enable the AI services module";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      ollama = {
        # Local LLM runner.
        enable = true;
        package =
          if config.modules.firmware.gpu.radeon.enableAcceleration then
            pkgs.ollama-rocm
          else if config.modules.firmware.gpu.nvidia.enableAcceleration then
            pkgs.ollama-cuda
          else
            pkgs.ollama;
        openFirewall = config.modules.services.network.enable;
      };
      open-webui = {
        # browser-accessible chat interface for ollama
        enable = true;
        # TODO fix this, currently broken.
        # port = 8080;
        openFirewall = config.modules.services.network.enable;
      };
    };
    systemd.services = {
      ollama = {
        # TODO test this.
        environment = lib.mkIf config.modules.firmware.gpu.radeon.enableAcceleration {
          ROCR_VISIBLE_DEVICES = "0";
          HSA_OVERRIDE_GFX_VERSION = "11.0.0";
        };
      };
    };
  };
}
