# AI related background services
# Eventually, would be nice to make these Daemon-less
{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.services.ollama;
in
{
  options.modules.services.ollama = {
    enable = lib.mkEnableOption "Enable the AI services module";
  };

  config = lib.mkIf cfg.enable {
    services.ollama = {
      enable = true;
      # package = if config.modules.firmware.gpu.radeon.enable then pkgs.ollama-rocm else pkgs.ollama;
      loadModels = [
        "qwen2.5-coder:7b"
        "qwen3.5:9b"
      ];
      syncModels = true;
    };
  };
}
