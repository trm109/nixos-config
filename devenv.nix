{ pkgs, ... }:
{
  # https://devenv.sh/basics/
  #env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.bat # For pretty printing files :)
  ];

  # https://devenv.sh/languages/
  languages.nix = {
    enable = true;
  };

  # https://devenv.sh/processes/

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts = {
    lint.exec = ''
      deadnix .
      statix check
      nixfmt .
    '';
    update.exec = ''
      nix flake update
    '';
    # TODO make hostname variable
    r-nixvim.exec = ''
      nix build .#nixosConfigurations.viceroy.config.programs.nixvim.build.package && \
      ./result/bin/nvim ./flake.nix
    '';
    clean-gen.exec = ''
      if [ "$EUID" -ne 0 ]
        then echo "Please run as root"
        exit
      fi
      nix-env --delete-generations +6 --profile /nix/var/nix/profiles/system
      /run/current-system/bin/switch-to-configuration boot
    '';
    repl.exec = ''
      nix repl --expr "builtins.getFlake \"$PWD\""
    '';
  };

  enterShell = ''
    echo "Entering NixOS development environment!"
    #update
    bat TODO.md
  '';

  # https://devenv.sh/tasks/

  # https://devenv.sh/tests/
  # NixOS Flake dry-run build
  # Run all bash scripts through shellcheck
  # Any other files should be run through their respective suites
  enterTest = ''
    nix flake check
  '';

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    # Bash/sh scripts check
    shellcheck.enable = true;
    # Find dead nix snippets
    deadnix.enable = true;
    # Opinionated nix formatting
    #alejandra.enable = true;
    nixfmt-rfc-style.enable = true;
    # Find nix anti-patterns
    statix.enable = true;
    # remove trailing whitespaces
    trim-trailing-whitespace.enable = true;
    # removes newlines at the end of the file
    end-of-file-fixer.enable = true;
  };
  # See full reference at https://devenv.sh/reference/options/
}
