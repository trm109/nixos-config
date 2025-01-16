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
    ags
    gh
    fastfetch
    jq
    yq
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
    devenv
    direnv
    insomnia
  ];
  programs.nix-ld.enable = true;
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
  programs.direnv = {
    enable = true;
    package = pkgs.unstable.direnv;
  };
  programs.neovim = {
    package = pkgs.neovim-unwrapped;
    enable = true;
    withRuby = true;
    withPython3 = true;
    withNodeJs = true;
  };
  programs.ssh.forwardX11 = true;
  programs.ssh.setXAuthLocation = true;
  programs.kdeconnect.enable = true;
  services.openssh.settings.X11Forwarding = true;
}
