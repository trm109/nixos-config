{ lib, config, pkgs, hostType, ... }:
let
  cfg = config.modules.hardware.razer;
in
{
  options.modules.hardware.razer = {
    enable = lib.mkEnableOption "Enables Razer specific programs" // {
      default = if hostType == "desktop" then true
      	else if hostType == "server" then false
        else true;
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.openrazer = {
      enable = true;
      users = [ "saik" ];
      batteryNotifier.enable = true;
    };
    environment.systemPackages = with pkgs; [
      polychromatic
    ];
  };
}
