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
    jq
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
    bluetui
    bat
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
    #neovim = {
    #  package = pkgs.neovim-unwrapped;
    #  enable = true;
    #  withRuby = true;
    #  withPython3 = true;
    #  withNodeJs = true;
    #};
    ssh.forwardX11 = true;
    ssh.setXAuthLocation = true;
    kdeconnect.enable = true;
    tmux.enable = true;
    nixvim = {
      # All nixvim options: https://nix-community.github.io/nixvim/search/
      enable = true;
      # autoCmd = {};
      # autoGroups = {};
      # build = {};
      # clipboard = {};
      colorschemes = {
        catppuccin.enable = true;
      };
      # userCommands = {};
      # diagnostics = {};
      # enableMan = true;
      # editorConfig = {};
      # filetype = {};

      # extraFiles = {};
      # extraConfigLua = {};
      # extraConfigLuaPost = {};
      # extraConfigLuaPre = {};
      # extraConfigVim = {};
      # extraLuaPackages
      extraPackages = [
        # extra packages, things like `conform` might require
        pkgs.alejandra
        pkgs.biome
        pkgs.black
      ];
      # extraPlugins = {};
      # extraPython3Packages = {};

      # highlight = {};
      # highlightOverride = {};
      # match = {};
      # keymaps = {};
      # keymapsOnEvents = {};
      # luaLoader = {};
      # performance = {};
      plugins = {
        neo-tree = {
          # https://github.com/nvim-neo-tree/neo-tree.nvim
          enable = true;
        };
        indent-blankline = {
          # https://github.com/lukas-reineke/indent-blankline.nvim
          enable = true;
        };
        conform-nvim = {
          # https://github.com/stevearc/conform.nvim
          enable = true;
          settings = {
            format_on_save = {
              lsp_fallback = "fallback";
              timeout_ms = 500;
            };
            formatters_by_ft = {
              css = ["prettier"];
              html = ["prettier"];
              json = ["prettier"];
              just = ["just"];
              lua = ["stylua"];
              nix = ["alejandra"];
              ruby = ["rubocop"];
              terraform = ["tofu_fmt"];
              tf = ["tofu_fmt"];
              yaml = ["yamlfmt"];
            };
            notify_no_formatters = true;
            notify_on_error = true;
          };
        };
        # LSP
        lsp = {
          enable = true;
        };
        # Adds browser-style tabs to the top
        bufferline = {
          enable = true;
        };
        # Fuzzy file finder
        telescope = {
          enable = true;
        };
        # statusline
      };
    };
  };
  # Enable SSH
  services = {
    openssh.enable = true;
    openssh.settings.X11Forwarding = true;
  };
}
