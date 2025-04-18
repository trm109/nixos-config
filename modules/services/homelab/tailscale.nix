{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.services.homelab.tailscale;
in
{
  options.modules.services.homelab.tailscale = {
    enable = lib.mkOption {
      default = false;
      description = "Enable Tailscale service";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "server";
    };
    environment.systemPackages = with pkgs; [
      tailscale
    ];
  };
}
