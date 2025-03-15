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
      #clipboard = {};
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
        # Library of 40+ independent Lua modules improving overall Neovim (version 0.8 and higher) experience with minimal effort
        mini = {
          #https://github.com/echasnovski/mini.nvim
          enable = true;
        };
        # Provides Nerd Font icons (glyphs) for use by neovim plugins
        web-devicons = {
          # https://github.com/nvim-tree/nvim-web-devicons
          enable = true;
        };
        # Neovim plugin to manage the file system and other tree like structures.
        neo-tree = {
          # https://github.com/nvim-neo-tree/neo-tree.nvim
          enable = true;
        };
        # Indent guides for Neovim
        indent-blankline = {
          # https://github.com/lukas-reineke/indent-blankline.nvim
          enable = true;
          settings = {
            scope = {
              enabled = true;
            };
          };
        };
        # Attempt to assume indentation style.
        guess-indent = {
          enable = true;
        };
        # Lightweight yet powerful formatter plugin for Neovim
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
        # Tree sitter
        treesitter = {
          enable = true;
        };
        # line numbers
        numbertoggle = {
          enable = true;
        };
        # statusline
        lualine = {
          enable = true;
        };
        # Markdown Preview
        markdown-preview = {
          enable = true;
        };
        # Clipboard History
        neoclip = {
          enable = true;
        };
      };
    };
  };
  # Enable SSH
  services = {
    openssh.enable = true;
    openssh.settings.X11Forwarding = true;
  };
}
