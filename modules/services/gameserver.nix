{
  config,
  lib,
  ...
}:
let
  cfg = config.modules.services.gameserver;
in
{
  options.modules.services.gameserver = {
    minecraft = {
      enable = lib.mkEnableOption "Enable the Minecraft server";
    };
    vintagestory = {
      enable = lib.mkEnableOption "Enable the Vintage Story server";
    };
  };
  config = {
    virtualisation.oci-containers.backend = "podman";
    users = lib.mkIf cfg.vintagestory.enable {
      users.vintagestory = {
        # createHome = false;
        group = "gameserver";
        linger = false;
        isNormalUser = true;
        uid = 3010;
      };
      groups.gameserver = {
        gid = 3010;
      };
    };
    systemd.tmpfiles.rules = lib.mkIf cfg.vintagestory.enable [
      "d /appdata/vintagestory 0755 ${toString config.users.users.vintagestory.uid} ${toString config.users.groups.gameserver.gid} -"
    ];

    virtualisation.oci-containers.containers = {
      vintagestory-server = lib.mkIf cfg.vintagestory.enable {
        # podman.user = "vintagestory";
        image = "zsuatem/vintagestory:1.22.0-rc.8";
        ports = [
          "42420:42420"
        ];
        volumes = [
          "/appdata/vintagestory:/vintagestory/data"
        ];
        environment = {
          PUID = toString config.users.users.vintagestory.uid;
          PGID = toString config.users.groups.gameserver.gid;
        };
      };
    };
    services.minecraft-servers = lib.mkIf cfg.minecraft.enable {
      enable = true;
      eula = true;
      openFirewall = true;
      #  servers.create-astral =
      #    let
      #      modpack = pkgs.fetchPackwizModpack {
      #        url = "https://github.com/Laskyyy/Create-Astral/blob/bda8b14df1dd8241420a7a7f44db34edb384f142/pack.toml";
      #        packHash = lib.fakeHash;
      #      };
      #      mcVersion = modpack.manifest.versions.minecraft;
      #      fabricVersion = modpack.manifest.versions.fabric;
      #      serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
      #    in
      #    {
      #      enable = true;
      #      package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabricVersion; };
      #      symlinks = {
      #        "mods" = "${modpack}/mods";
      #      };
      #    };
    };
  };
}
