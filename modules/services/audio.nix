# Settings for devices that use audio
{
  lib,
  pkgs,
  config,
  hostType,
  ...
}:
let
  cfg = config.modules.services.audio;
in
{
  options.modules.services.audio = {
    enable = lib.mkOption {
      default = hostType == "desktop" || false;
      description = "Enable the audio services module";
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      helvum # TODO if a graphical session is present
      pavucontrol # TODO if a graphical session is present
    ];
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
