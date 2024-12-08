{ pkgs, ... }:
{
# font
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      comic-mono
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      google-fonts
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Comic Mono" "FiraCode" "DroidSansMono" ];
    };
  };
  time.timeZone = "America/New_York";
}
