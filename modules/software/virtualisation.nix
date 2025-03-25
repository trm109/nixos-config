{pkgs, ...}: {
  # Enable common container config files in /etc/containers
  virtualisation = {
    #containers.enable = true;
    #libvirtd.enable = true;
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
    #lxd = {
    #  enable = true;
    #  ui.enable = true;
    #};
  };
  # Useful otherdevelopment tools
  environment.systemPackages = with pkgs; [
    podman-compose
    #dive # look into docker image layers
    #docker-compose # start group of containers for dev
    #gnome-boxes
  ];
}
