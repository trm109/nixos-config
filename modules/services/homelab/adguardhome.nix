{ config, lib, ... }:
let
  cfg = config.modules.services.homelab.adguardhome;
in
{
  options.modules.services.homelab.adguardhome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.modules.services.homelab.enable || false;
      description = "Enable AdGuard Home";
    };
    filters = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt" # AdGuard Base filter
        "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt" # Adblock Pro filter
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt" # Filter Phishing domains
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_12.txt" # Anti-mailware list
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt" # Filter Phishing domains based on PhishTank and OpenPhish lists"
        "https://raw.githubusercontent.com/AdguardTeam/FiltersRegistry/master/filters/filter_11_Mobile/filter.txt" # AdGuard Mobile Ads filter
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_2.txt" # AdAway blocklist
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_7.txt" # Perflys and Dandelion Sprout's Smart-TV Blocklist
      ];
      description = "List of filter URLs to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      nameservers = [
        "127.0.0.1"
      ];
      firewall = {
        allowedUDPPorts = [
          53
          29222
        ];
        allowedTCPPorts = [
          53
          29222
        ];
      };
    };
    services.adguardhome = {
      enable = true;
      port = 29222; # Web UI port
      settings = {
        #http = { };
        #http.port = 29222;
        #http = {
        #  address = "127.0.0.1:29222";
        #};
        dns = {
          bind_hosts = [
            "0.0.0.0"
          ];
          trusted_proxies = [
            "127.0.0.1" # localhost
            "192.168.50.0/24" # local network
            "100.64.0.0/10" # tailnet
          ];
          bootstrap_dns = [ "1.1.1.1" ];
          upstream_dns = [
            "https://security.cloudflare-dns.com/dns-query"
            "https://dns.quad9.net/dns-query"
          ];
          fallback_dns = [
            "https://dns.google/dns-query"
          ];
        };
        filtering = {
          filtering_enabled = true;
        };
        filters = map (url: {
          name = url;
          inherit url;
        }) cfg.filters;
      };
    };
  };
}
