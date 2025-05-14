let
  hosts = {
    plex-3 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIQrIk6JHcuxlQ4EWXr+DuvIuaBMF2VlcPoMLtXeY1Rb";
    plex-2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO6+ijDF6zaCnlDzCL7wZC+V9mhL1RV5BBVxcuO0rqIU";
    plex-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEYob0+sv/2ZHTzNFZxLTVpTOnuHRpA+c/xyn2a/m01p";
    plex-0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNNE769ehQ8NoDm/tcz/oafehsysGN0taoLfafuha0A";
    viceroy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICppn/DPe6WPH6JXAP+cIb8qsHVR6fgD6YpS11cuF4N2";
    #TODO add asus-flow
  };
  users = {
    saik = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEwHC0dPH+1iqtVZWVEJ+wLmJK17A/TzdcNGNRWrGK6";
  };
in
#allUsers = builtins.attrValues users;
#allHosts = builtins.attrValues hosts;
{
  # Teslamate
  "teslamate/encryption_key.age".publicKeys = [
    users.saik
    hosts.plex-0
    hosts.plex-1
    hosts.plex-2
    hosts.plex-3
  ];
  "teslamate/refresh_token.age".publicKeys = [ users.saik ];
  "homelab/teslamate-core-env.age".publicKeys = [
    users.saik
    hosts.plex-0
    hosts.plex-1
    hosts.plex-2
    hosts.plex-3
  ];
  "homelab/teslamate-grafana-env.age".publicKeys = [
    users.saik
    hosts.plex-0
    hosts.plex-1
    hosts.plex-2
    hosts.plex-3
  ];
  "homelab/teslamate-db-env.age".publicKeys = [
    users.saik
    hosts.plex-0
    hosts.plex-1
    hosts.plex-2
    hosts.plex-3
  ];
  "tailscale/auth_key.age".publicKeys = [
    users.saik
    hosts.plex-0
    hosts.plex-1
    hosts.plex-2
    hosts.plex-3
    hosts.viceroy
  ];
  "homelab/k3s-token.age".publicKeys = [
    users.saik
    hosts.viceroy
    hosts.plex-0
    hosts.plex-1
    hosts.plex-2
    hosts.plex-3
  ];
}
