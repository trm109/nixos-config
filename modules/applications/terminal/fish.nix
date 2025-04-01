{
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.applications.terminal.fish;
in
{
  options.modules.applications.terminal.fish = {
    enable = lib.mkOption {
      default = true;
      description = "Enable fish shell";
    };
  };
  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
    };
    environment.systemPackages = with pkgs.fishPlugins; [
      done # Automatically receive notifications when long processes finish
      fzf-fish # Fish shell key bindings for fzf
      forgit # A utility tool powered by fzf for using git interactively
      hydro # Ultra-pure, lag-free prompt with async Git status
      tide # Ultimate Fish prompt
      sponge # keeps your fish shell history clean from typos, incorrectly used commands and everything you don't want to store due to privacy reasons
      colored-man-pages # Fish shell plugin to colorize man pages
    ];
  };
}
