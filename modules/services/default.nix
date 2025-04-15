{
  lib,
  config,
  ...
}:
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
    ./ssh.nix
    ./keyring.nix
    ./home-assistant.nix
    ./teslamate.nix
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
      keyring.enable = false;
      ssh.enable = false;
      home-assistant.enable = false;
      teslamate.enable = false;
    };
  };
}
