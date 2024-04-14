{ lib, config, pkgs, hostType, ... }:
let
  cfg = config.modules.hardware.audio;
in
{
  options.modules.hardware.audio = {
    enable = lib.mkEnableOption "Enables audio" // {
      default = if hostType == "desktop" then true
      	else if hostType == "server" then false
        else true;
    };
  };

  config = lib.mkIf cfg.enable {
    sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };
}
