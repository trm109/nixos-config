{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.applications.terminal.virt;
in
{
  options.modules.applications.terminal.virt = {
    enable = lib.mkOption {
      default = true;
      description = "Enable virtualisation tools";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      podman-compose
    ];
    virtualisation = {
      podman = {
        enable = true;
      };
    };
  };
}
