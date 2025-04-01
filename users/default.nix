# users/default.nix
{
  pkgs,
  users,
  ...
}:
{
  # This takes 'users' (array) and maps each user to a nix file
  imports = map (x: "${./.}/" + x + ".nix") users;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
}
