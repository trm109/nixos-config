{
  lib,
  config,
  ...
}:
let
  cfg = config.modules.system.locale;
in
{
  options.modules.system.locale = {
    enable = lib.mkOption {
      default = true;
      description = "Enable the locale module";
    };
  };
  config = lib.mkIf cfg.enable {
    # font
    #fonts = {
    #  enableDefaultPackages = true;
    #  packages = with pkgs; [
    #    comic-mono
    #    nerd-fonts.fira-code
    #    nerd-fonts.droid-sans-mono
    #    google-fonts
    #  ];
    #  fontconfig.defaultFonts = {
    #    monospace = [
    #      "Comic Mono"
    #      "FiraCode"
    #      "DroidSansMono"
    #    ];
    #  };
    #};
    time.timeZone = "America/Chicago";
  };
}
