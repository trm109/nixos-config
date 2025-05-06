# applications that depend on having a graphical session
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.applications.terminal;
in
{
  imports = [
    ./fish.nix
    ./virt.nix
    ./nixvim.nix
  ];

  options.modules.applications.terminal = {
    enable = lib.mkOption {
      default = true;
      description = "Enable terminal applications";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gcc # C compiler
      binutils_nogold # ??

      wget # download files
      git # version control
      unzip # unzip files
      btop # system resource monitor
      tre-command # tree command
      grc # wanted by fish
      gh # github cli
      fastfetch # fetches system info
      fzf # fuzzy finder
      tldr # man pages, but better
      devenv
      #(devenv.override {
      #  rustPlatform = pkgs.rustPlatform // {
      #    buildRustPackage =
      #      args:
      #      pkgs.rustPlatform.buildRustPackage (
      #        args
      #        // {
      #          src = pkgs.fetchFromGitHub {
      #            owner = "cachix";
      #            repo = "devenv";
      #            rev = "v1.5.2";
      #            hash = "sha256-rXtUUxfQ34ukTy2OyHwuypnSgK95FRPGwJf69QnWMrc=";
      #          };
      #          cargoHash = "sha256-oiOh8m7MypViLbzy/13NpSiOwkfRwybUpDs91f+HbGA=";
      #        }
      #      );
      #  };
      #})

      direnv
      bat # cat clone
      rclone # file sync

      # nix stuff
      nix-prefetch-git
      nix-prefetch-github
      nix-search-cli
    ];
    programs = {
      tmux = {
        enable = true;
      };
      nix-ld = {
        enable = true;
      };
      direnv = {
        enable = true;
      };
    };
  };
}
