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

    chezmoi

    tldr
  ];

  # Enable SSH
  services.openssh.enable = true;
  networking.firewall = { 
    enable = true;
    allowedTCPPortRanges = [ 
    { from = 1714; to = 1764; } # KDE Connect
    ];  
    allowedUDPPortRanges = [ 
    { from = 1714; to = 1764; } # KDE Connect
    ];  
  };  
  programs.ssh.forwardX11 = true;
  programs.ssh.setXAuthLocation = true;
  programs.kdeconnect.enable = true;
  services.openssh.settings.X11Forwarding = true;
}
