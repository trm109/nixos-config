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
    nix-prefetch-git
    openvpn
    openresolv

    #chezmoi CRINGE

    tldr
  ];

  # Enable SSH
  services.openssh.enable = true;
  networking.firewall.enable = false;
  programs.ssh.forwardX11 = true;
  programs.ssh.setXAuthLocation = true;
  services.openssh.settings.X11Forwarding = true;
}
