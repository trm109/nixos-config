{ pkgs, ... }:
{
# Enable common container config files in /etc/containers
  virtualisation = {
    docker = {
      enable = true;
    };
    containers.enable = true;
    libvirtd.enable = true;
    virtualbox.host.enable = true;
    virtualbox.host.enableExtensionPack = true;
  };

  # Useful otherdevelopment tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    docker-compose # start group of containers for dev
    gnome-boxes
  ];
}
