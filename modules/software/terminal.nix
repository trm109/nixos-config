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
    fastfetch
# Fish stuff
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
  ];

  # Enable SSH
  services.openssh.enable = true;
  networking.firewall.enable = false;
}
