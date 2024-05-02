{ unstable, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  system.stateVersion = "23.11";
}
