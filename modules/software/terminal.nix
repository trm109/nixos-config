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
    (
      devenv.override
      (
        old: {
          rustPlatform =
            old.rustPlatform
            // {
              buildRustPackage = args:
                old.rustPlatform.buildRustPackage (
                  args
                  // {
                    verison = "1.4.0";
                    src = old.fetchFromGitHub {
                      owner = "trm109";
                      repo = "devenv-no-ai";
                      rev = "5a7d859293c24e930942b0a777bddb9551476975";
                      hash = "sha256-BFdIoDLJnyrw/ba42Gd5cIJNagc+Rkofh5xALbhVzLg=";
                    };
                    cargoHash = "sha256-kJ5N34SoIUtDxHDiZKo4+eQiUf11ibvzA0/4H5olQdY=";
                  }
                );
            };
        }
      )
    )
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
