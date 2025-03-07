{pkgs, ...}: {
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
  scripts.lint.exec = ''
    deadnix .
    statix check
    alejandra .
  '';
  scripts.update.exec = ''
    nix flake update --flake /etc/nixos
  '';

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
    nixos-rebuild dry-build --flake /etc/nixos#viceroy
  '';

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    # Bash/sh scripts check
    shellcheck.enable = true;
    # Find dead nix snippets
    deadnix.enable = true;
    # Opinionated nix formatting
    alejandra.enable = true;
    # Find nix anti-patterns
    statix.enable = true;
  };
  # See full reference at https://devenv.sh/reference/options/
}
