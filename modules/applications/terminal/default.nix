# applications that depend on having a graphical session
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.applications.terminal;
in
{
  options.modules.applications.terminal = {
    enable = lib.mkOption {
      default = true;
      description = "Enable terminal applications";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc # C compiler
      binutils_nogold # ??
      wget # download files
      git # version control
    ];
    programs = {
      nix-ld = {
        enable = true;
      };
    };
  };
}
