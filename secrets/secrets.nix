let
  hosts = {
    plex-0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICNNE769ehQ8NoDm/tcz/oafehsysGN0taoLfafuha0A";
    viceroy = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICppn/DPe6WPH6JXAP+cIb8qsHVR6fgD6YpS11cuF4N2";
    #TODO add asus-flow
  };
  users = {
    # ssh-keygen -t ed25519
    saik = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG0dOeMjrqq3Hd26UY7b/HLUh+bYgsdSFZTn39n+cEiS";
  };
  #allUsers = builtins.attrValues users;
  #allHosts = builtins.attrValues hosts;
in
{
  #"secret.age".publicKeys = allUser ++ allHosts;
  "teslamate.age".publicKeys = [
    users.saik
    hosts.plex-0
  ];
  "teslamate_db.age".publicKeys = [
    users.saik
    hosts.plex-0
  ];
  "teslamate_mqtt.age".publicKeys = [
    users.saik
    hosts.plex-0
  ];
  "teslamate_encryption.age".publicKeys = [
    users.saik
    hosts.plex-0
  ];
}
