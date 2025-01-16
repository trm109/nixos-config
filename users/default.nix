# users/default.nix
{
  pkgs,
  users,
  ...
}: {
  #map (x: "foo" + x) [ "bar" "bla" "abc" ]
  imports = map (x: "${./.}/" + x + ".nix") users;
  #imports = [
  #  ./${users}.nix
  #];
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}
