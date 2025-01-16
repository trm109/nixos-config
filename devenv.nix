{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/basics/
  #env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
    pkgs.nixfmt-rfc-style
  ];

  # https://devenv.sh/languages/
  languages.nix = {
    enable = true;
  };

  # https://devenv.sh/processes/

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/

  enterShell = ''
    echo "Entering NixOS devenv shell"
  '';

  # https://devenv.sh/tasks/

  # https://devenv.sh/tests/
  # NixOS Flake dry-run build
  # Run all bash scripts through shellcheck
  # Any other files should be run through their respective suites
  enterTest = ''
    
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
