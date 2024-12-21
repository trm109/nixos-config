{ unstable, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    extraOptions = ''
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
      '';
  };
  system.stateVersion = "23.11";
}
