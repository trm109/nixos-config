{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.modules.services.keyring;
in
{
  options.modules.services.keyring = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable the keyring service.
      '';
    };
  };

  config =
    let
      normalUsernames = [
        "saik"
        "sara"
      ];
    in
    lib.mkIf cfg.enable {
      # enable kwallet for all users
      environment.systemPackages = [
        pkgs.kdePackages.kwalletmanager
      ];
      security.pam.services =
        {
          login.kwallet = {
            enable = true;
            package = pkgs.kdePackages.kwallet-pam;
          };
          greetd.kwallet = {
            enable = true;
            package = pkgs.kdePackages.kwallet-pam;
            forceRun = true;
          };
        }
        // lib.genAttrs normalUsernames (_: {
          kwallet = {
            enable = true;
            forceRun = true;
          };
        });
    };
}
