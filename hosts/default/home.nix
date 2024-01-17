{ config, pkgs, ... }:

{
# Home Manager needs a bit of information about you and the paths it should
# manage.
home.username = "saik";
home.homeDirectory = "/home/saik";


# setting git.
programs.git = {
  enable = true;
  userName = "trm109";
  userEmail = "trm109@case.edu";
};

# gtk
#  programs.gtk = {
#    enable = true;
#    theme.name = "Adwaita";
#    iconTheme.name = "Adwaita";
#    cursorTheme.name = "Adwaita";
#  };

# mime types
xdg.mimeApps.defaultApplications = {
  "text/plain" = [ "nvim.desktop" ];
  "application/pdf" = [ "chromium.desktop" ];
  "image/*" = [ "chromium.desktop" ];
  "video/*" = [ "mpv.desktop" ];
};

# This value determines the Home Manager release that your configuration is
# compatible with. This helps avoid breakage when a new Home Manager release
# introduces backwards incompatible changes.
#
# You should not change this value, even if you update Home Manager. If you do
# want to update the value, then make sure to first check the Home Manager
# release notes.
home.stateVersion = "23.11"; # Please read the comment before changing.

# The home.packages option allows you to install Nix packages into your
# environment.
home.packages = [
# # Adds the 'hello' command to your environment. It prints a friendly
# # "Hello, world!" when run.
# pkgs.hello

# # It is sometimes useful to fine-tune packages, for example, by applying
# # overrides. You can do that directly here, just don't forget the
# # parentheses. Maybe you want to install Nerd Fonts with a limited number of
# # fonts?
# (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

# # You can also create simple shell scripts directly inside your
# # configuration. For example, this adds a command 'my-hello' to your
# # environment:
# (pkgs.writeShellScriptBin "my-hello" ''
#   echo "Hello, ${config.home.username}!"
# '')
    ];

# Home Manager is pretty good at managing dotfiles. The primary way to manage
# plain files is through 'home.file'.
home.file = {
# # Building this configuration will create a copy of 'dotfiles/screenrc' in
# # the Nix store. Activating the configuration will then make '~/.screenrc' a
# # symlink to the Nix store copy.
# ".screenrc".source = dotfiles/screenrc;

# # You can also set the file content immediately.
# ".gradle/gradle.properties".text = ''
#   org.gradle.console=verbose
#   org.gradle.daemon.idletimeout=3600000
# '';
    };

# Home Manager can also manage your environment variables through
# 'home.sessionVariables'. If you don't want to manage your shell through Home
# Manager then you have to manually source 'hm-session-vars.sh' located at
# either
#
#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#
# or
#
#  /etc/profiles/per-user/saik/etc/profile.d/hm-session-vars.sh
#
home.sessionVariables = {
# EDITOR = "emacs";
TESTING = "testing";
    };

#Neovim
programs.neovim = 
let 
  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
in 
  {
# Enable
    enable = true;

    # Alias vim to Neovim
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Other configs
    withPython3 = true;
    defaultEditor = true;

    # Add in extra packages requirede for plugins
    extraPackages = with pkgs; [
      lua-language-server
      rnix-lsp
      wl-clipboard
      go
      nodePackages.pyright
      luajitPackages.luarocks
      php82Packages.composer
      julia_18
      python311Packages.pip
      php
    ];

    # Add in lua configs
    extraLuaConfig = ''
	${builtins.readFile ../../modules/home-manager/neovim/options.lua}
    '';
    # extraLuaConfig = ''
    # ${builtins.readFile ./nvim/options.lua}
    # ${builtins.readFile ./nvim/plugins/cmp.lua}
    # ${builtins.readFile ./nvim/plugins/lsp.lua}
    # ${builtins.readFile ./nvim/telescope.lua}
    # ${builtins.readFile ./nvim/treesitter.lua}
    # '';

    plugins = with pkgs.vimPlugins; [
    # 💤 A modern plugin manager for Neovim
    # https://github.com/folke/lazy.nvim
    {
      plugin = lazy-nvim;
      config = toLuaFile ../../modules/home-manager/neovim/plugins/lazy.lua;
    }

    #    # Quickstart configs for Nvim LSP
    #    # https://github.co../../modules/home-manager/neovim/nvim-lspconfig
    #    {
    #        plugin = nvim-lspconfig;
    #        config = toLuaFile ../../modules/home-manager/neovim/plugins/lsp.lua;
    #    }
    #    
    #    #⚡ Smart and Powerful commenting plugin for neovim ⚡
    #    # https://github.com/numToStr/Comment.nvim
    #    {
    #        plugin = comment-nvim;
    #        config = toLua "require(\"Comment\").setup()";
    #    }


    #    # A port of gruvbox community theme to lua with treesitter and semantic highlights support!
    #    # https://github.com/ellisonleao/gruvbox.nvim
    #    {
    #        plugin = gruvbox-nvim;
    #        config = "colorscheme gruvbox";
    #    }

    #    # Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
    #    # https://github.com/folke/neodev.nvim
    #    neodev-nvim
    #    
    #    # A completion engine plugin for neovim written in Lua. Completion sources are installed from external repositories and "sourced".
    #    # https://github.com/hrsh7th/nvim-cmp
    #    {
    #        plugin = nvim-cmp;
    #        config = toLuaFile ../../modules/home-manager/neovim/plugins/cmp.lua;
    #    }
    #    
    #    # telescope.nvim is a highly extendable fuzzy finder over lists. Built on the latest awesome features from neovim core. Telescope is centered around modularity, allowing for easy customization.
    #    # https://github.com/nvim-telescope/telescope.nvim
    #    {
    #        plugin = telescope-nvim;
    #        config = toLuaFile ../../modules/home-manager/neovim/plugins/telescope.lua;
    #    }

    #    # fzf-native is a c port of fzf. It only covers the algorithm and implements few functions to support calculating the score.
    #    # https://github.com/nvim-telescope/telescope-fzf-native.nvim
    #    telescope-fzf-native-nvim

    #    # luasnip completion source for nvim-cmp
    #    # https://github.com/saadparwaiz1/cmp_luasnip
    #    cmp_luasnip

    #    # nvim-cmp source for neovim's built-in language server client.
    #    # https://github.com/hrsh7th/cmp-nvim-lsp
    #    cmp-nvim-lsp
    #    
    #    # Snippet Engine for Neovim written in Lua.
    #    # https://github.com/L3MON4D3/LuaSnip
    #    luasnip

    #    # Set of preconfigured snippets for different languages.
    #    # https://github.com/rafamadriz/friendly-snippets
    #    friendly-snippets

    #    # A blazing fast and easy to configure neovim statusline plugin written in pure lua.
    #    # https://github.com/nvim-lualine/lualine.nvim
    #    lualine-nvim

    #    # lua `fork` of vim-web-devicons for neovim
    #    # https://github.com/nvim-tree/nvim-web-devicons
    #    nvim-web-devicons

    #    # Vim configuration files for Nix http://nixos.org/nix
    #    # https://github.com/LnL7/vim-nix
    #    vim-nix

    ## A file explorer tree for neovim written in lua
    ## https://github.com/nvim-tree/nvim-tree.lua
    #nvim-tree-lua

    ## 💥 Create key bindings that stick. WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible keybindings of the command you started typing.
    ## https://github.com/folke/which-key.nvim
    #which-key-nvim

    ## Maintained fork of the fastest Neovim colorizer
    ## https://github.com/NvChad/nvim-colorizer.lua
    #nvim-colorizer-lua

    ## Git integration for buffers
    ## https://github.com/lewis6991/gitsigns.nvim
    #gitsigns-nvim

    ## autopairs for neovim written by lua
    ## https://github.com/windwp/nvim-autopairs
    #nvim-autopairs

    #    # Tree sitter plugins
    #    {
    #        plugin = (nvim-treesitter.withPlugins (p: [
    #            p.tree-sitter-nix
    #            p.tree-sitter-vim
    #            p.tree-sitter-bash
    #            p.tree-sitter-lua
    #            p.tree-sitter-python
    #            p.tree-sitter-nix
    #        ]));
    #        config = toLuaFile ../../modules/home-manager/neovim/plugins/treesitter.lua;
    #    }
    ];
  };



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
