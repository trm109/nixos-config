{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim
    wget
    git
    unzip
    gcc
    binutils_nogold
    rustup
    btop
    tre-command
    unstable.ags
    gh
# Fish stuff
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
  ];
}
