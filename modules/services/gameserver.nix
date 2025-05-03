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
  };
  config = {
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
