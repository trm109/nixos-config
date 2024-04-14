{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    kitty
    chromium
    (prismlauncher.override { jdks = [ jdk8 jdk17 ]; })
    vesktop
    steam
    spotify
  ];
}
