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
    nix-prefetch-github
    #waypipe # Graphical forwarding over ssh
    bluetui
    bat
  ];

  services = {
    # Bans IPs that show malicious signs
    fail2ban = {
      #wantedBy = lib.mkForce [];
      enable = true;
    };
    # Home VPN
    #headscale = {
    #  enable = true;
    #  address = "0.0.0.0";
    #  port = 443;
    #  settings = {
    #    dns.magic_dns = false;
    #    server_url = "https://murray-hill.asuscomm.com:443";
    #  };
    #};
    # SSH server
    openssh = {
      #wantedBy = lib.mkForce [];
      enable = true;
      settings.X11Forwarding = true;
    };
  };
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
    # Run unpatched dynamic binaries on NixOS
    nix-ld.enable = true;
    # It augments existing shells with a new feature that can load and unload environment variables depending on the current directory.
    direnv = {
      enable = true;
      package = pkgs.unstable.direnv;
    };
    # SSH Client
    ssh = {
      forwardX11 = true;
      setXAuthLocation = true;
    };
    # Mobile device connectivity
    kdeconnect.enable = true;
    # Terminal multiplexer
    tmux.enable = true;
    # Neovim Config with Nix Stubs
    nixvim = {
      # All nixvim options: https://nix-community.github.io/nixvim/search/
      enable = true;
      # autoCmd = {};
      # autoGroups = {};
      # build = {};
      clipboard = {
        register = "unnamedplus";
        providers = {
          wl-copy.enable = true;
        };
      };
      colorschemes = {
        catppuccin.enable = true;
      };
      # userCommands = {};
      # diagnostics = {};
      # enableMan = true;
      editorconfig = {
        enable = true;
      };
      # filetype = {};
      opts = {
        number = true;
        relativenumber = true;
      };
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
        # Treesitter, a syntax tree generator
        treesitter = {
          enable = true;
        };
        dressing = {
          enable = true;
        };
        nui = {
          enable = true;
        };
        web-devicons = {
          enable = true;
        };
        mini = {
          enable = true;
        };
        # Folder tree view :Neotree
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
              ts = ["biome"];
              tsx = ["biome"];
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
        # CMP - A completion plugin for neovim coded in Lua.
        cmp = {
          enable = true;
        };
        # GitHub Copilot
        copilot-lua = {
          enable = true;
          settings = {
            suggestion = {
              keymap.accept = "<A-l>";
              auto_trigger = true;
            };
          };
        };
        # whichkey
        which-key = {
          enable = true;
        };
        # Inline markdown renderer
        render-markdown = {
          enable = true;
          settings = {
            file_types = [
              "Avante"
            ];
          };
        };
        # Cursor AI helper
        #avante = {
        #  enable = true;
        #  package = pkgs.vimPlugins.avante-nvim;
        #  settings = {
        #    provider = "ollama";
        #    vendors = {
        #      ollama = {
        #        __inherited_from = "openai";
        #        endpoint = "http://127.0.0.1:11434/v1";
        #        model = "qwen2.5-coder:3b";
        #        disable_tools = true;
        #      };
        #    };
        #    diff = {
        #      autojump = true;
        #      debug = false;
        #      list_opener = "copen";
        #    };
        #    highlights = {
        #      diff = {
        #        current = "DiffText";
        #        incoming = "DiffAdd";
        #      };
        #    };
        #    hints = {
        #      enabled = true;
        #    };
        #    mappings = {
        #      diff = {
        #        both = "cb";
        #        next = "]x";
        #        none = "c0";
        #        ours = "co";
        #        prev = "[x";
        #        theirs = "ct";
        #      };
        #    };
        #    windows = {
        #      sidebar_header = {
        #        align = "center";
        #        rounded = true;
        #      };
        #      width = 30;
        #      wrap = true;
        #    };
        #  };
        #};
        git-conflict = {
          enable = true;
        };
        avante = {
          enable = true;
          package = pkgs.vimPlugins.avante-nvim.overrideAttrs {
            version = "main";
            src = pkgs.fetchFromGitHub {
              owner = "yetone";
              repo = "avante.nvim";
              rev = "1c8cac1958cdf04b65942f23fa5a14cc4cfae44e";
              hash = "sha256-UXt8c2esrAE9SzaQGRGZ4hdkKsYuo1Ftvn+JR80W15I=";
            };
            nvimSkipModule = [
              "avante.providers.ollama"
              "avante.providers.vertex_claude"
              "avante.providers.azure"
              "avante.providers.copilot"
            ];
            postInstall = let
              ext = pkgs.stdenv.hostPlatform.extensions.sharedLibrary;
              avante-nvim-lib = pkgs.rustPlatform.buildRustPackage {
                pname = "avante-nvim-lib";
                version = "main";
                src = pkgs.fetchFromGitHub {
                  owner = "yetone";
                  repo = "avante.nvim";
                  rev = "1c8cac1958cdf04b65942f23fa5a14cc4cfae44e";
                  sha256 = "sha256-UXt8c2esrAE9SzaQGRGZ4hdkKsYuo1Ftvn+JR80W15I=";
                };

                #cargoHash = "sha256-7W7uuyzqTTlvZAkeRYRIfkxYVbOv5h7elH8noZe1VMQ=";
                useFetchCargoVendor = true;
                cargoHash = "sha256-pmnMoNdaIR0i+4kwW3cf01vDQo39QakTCEG9AXA86ck=";

                nativeBuildInputs = [
                  pkgs.pkg-config
                  pkgs.perl
                ];

                buildInputs = [
                  pkgs.openssl
                  pkgs.perl
                ];

                buildFeatures = ["luajit"];

                checkFlags = [
                  # Disabled because they access the network.
                  "--skip=test_hf"
                  "--skip=test_public_url"
                  "--skip=test_roundtrip"
                  "--skip=test_fetch_md"
                ];
              };
            in ''
              mkdir -p $out/build
              ln -s ${avante-nvim-lib}/lib/libavante_repo_map${ext} $out/build/avante_repo_map${ext}
              ln -s ${avante-nvim-lib}/lib/libavante_templates${ext} $out/build/avante_templates${ext}
              ln -s ${avante-nvim-lib}/lib/libavante_tokenizers${ext} $out/build/avante_tokenizers${ext}
              ln -s ${avante-nvim-lib}/lib/libavante_html2md${ext} $out/build/avante_html2md${ext}
            '';
          };
          settings = {
            provider = "ollama";
            ollama = {
              endpoint = "localhost:11434";
              model = "qwen2.5-coder:3b";
              #options = {
              #  #disable_tools = true;
              #  num_ctx = 16384;
              #};
            };
          };
        };
      };
      extraPlugins = [
        # Line number toggles
        (pkgs.vimUtils.buildVimPlugin {
          name = "nvim-numbertoggle";
          src = pkgs.fetchFromGitHub {
            owner = "sitiom";
            repo = "nvim-numbertoggle";
            rev = "c5827153f8a955886f1b38eaea6998c067d2992f";
            hash = "sha256-IkJ9KRrikJZvijjfqgnJ2/QYAuF8KX2/zFX1oUbE3aI=";
          };
        })
        #(pkgs.vimUtils.buildVimPlugin {
        #  name = "avante";
        #  src = pkgs.fetchFromGitHub {
        #    owner = "yetone";
        #    repo = "avante.nvim";
        #    rev = "1c8cac1958cdf04b65942f23fa5a14cc4cfae44e";
        #    hash = "sha256-UXt8c2esrAE9SzaQGRGZ4hdkKsYuo1Ftvn+JR80W15I=";
        #  };
        #})
        #((pkgs.vimPlugins.avante-nvim.override {
        #    })
        #  .overrideAttrs (oldAttrs: {
        #    src = pkgs.fetchFromGitHub {
        #      owner = "yetone";
        #      repo = "avante.nvim";
        #      rev = "1c8cac1958cdf04b65942f23fa5a14cc4cfae44e";
        #      sha256 = "sha256-UXt8c2esrAE9SzaQGRGZ4hdkKsYuo1Ftvn+JR80W15I=";
        #    };
        #    nvimSkipModule = oldAttrs.nvimSkipModule ++ ["avante.providers.ollama" "avante.providers.vertex_claude"];
        #  }))
        #(pkgs.vimPlugins.img-clip-nvim.override
        #  {
        #    plugin = pkgs.vimPlugins.img-clip-nvim;
        #    config = "lua require('img-clip').setup()";
        #  })
        pkgs.vimPlugins.img-clip-nvim
      ];
    };
  };
}
