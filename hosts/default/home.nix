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

# TODO: Convert to seperate .nix file modules.
# Neovim
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
      ripgrep
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

    # IMPORTANT!
    # Besides Lazy, all plugins are managed by lazy.nvim in the modules/home-manager/neovim/plugins/lazy.lua file
    plugins = with pkgs.vimPlugins; [
    # 💤 A modern plugin manager for Neovim
    # https://github.com/folke/lazy.nvim
    {
      plugin = lazy-nvim;
      config = toLuaFile ../../modules/home-manager/neovim/plugins/lazy.lua;
    }
  ];
};



  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
