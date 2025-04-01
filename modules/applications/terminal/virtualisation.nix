{
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.applications.terminal.virtualisation;
in
{
  options.modules.applications.terminal.virtualisation = {
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
        autoPrune = true;
        dockerCompat = true;
      };
    };
  };
}
