_: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sara = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "video" "input"]; # Enable ‘sudo’ for the user.
  };
}
