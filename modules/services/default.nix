{ lib, ... }:
let
  cfg = config.modules.services;
in
{
  imports = [
    ./ai.nix
    ./audio.nix
    ./battery.nix
    ./bluetooth.nix
    ./network.nix
    ./printers.nix
    ./razer.nix
  ];
  options.modules.services = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the services module";
    };
  };
  config = lib.mkIf (!cfg.enable) {
    modules.services = {
      ai.enable = false;
      audio.enable = false;
      battery.enable = false;
      bluetooth.enable = false;
      network.enable = false;
      printers.enable = false;
      razer.enable = false;
    };
  };
}
