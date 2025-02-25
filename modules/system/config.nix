{
  #TODO Can move this to flake?
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };
  security = {
    pam.services.kwallet = {
      name = "kwallet";
      enableKwallet = true;
    };
  };
  services = {
    fwupd.enable = true;
  };
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      settings = {
        default-cache-ttl = 2592000;
        max-cache-ttl = 2592000;
      };
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +5";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
    extraOptions = ''
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
      trusted-users = root saik
    '';
  };
  system.stateVersion = "23.11";
}
