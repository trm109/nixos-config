{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.saik = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "docker"
      "libvirtd"
      "vboxusers"
      "k3s"
      "gamemode"
      "lxd"
      "keyd"
    ]; # Enable ‘sudo’ for the user.
  };
}
