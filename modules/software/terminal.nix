{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    wget
    git
    unzip
    gcc
    grc # dunno what this does but fish says I need it
    binutils_nogold
    btop
    tre-command
    grc
    gh
    fastfetch
    jo
    jq
    yq
    # Fish stuff
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    nix-prefetch-git
    tldr
    devenv
    insomnia
    nix-search-cli
    #waypipe # Graphical forwarding over ssh
  ];

  services.fail2ban.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];
  };
  programs = {
    nix-ld.enable = true;
    direnv = {
      enable = true;
      package = pkgs.unstable.direnv;
    };
    neovim = {
      package = pkgs.neovim-unwrapped;
      enable = true;
      withRuby = true;
      withPython3 = true;
      withNodeJs = true;
    };
    ssh.forwardX11 = true;
    ssh.setXAuthLocation = true;
    kdeconnect.enable = true;
    tmux.enable = true;
  };
  # Enable SSH
  services = {
    openssh.enable = true;
    openssh.settings.X11Forwarding = true;
  };
}
