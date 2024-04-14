{ unstable, ... }:
{
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  system.stateVersion = "23.11";
}
