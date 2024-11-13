{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
    jq
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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
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
