{ pkgs, ... }:
{
# font
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      comic-mono
        (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Comic Mono" "FiraCode" "DroidSansMono" ];
    };
  };
  time.timeZone = "America/New_York";
}
