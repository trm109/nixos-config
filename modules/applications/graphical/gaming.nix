{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.modules.applications.graphical.gaming;
in
{
  options.modules.applications.graphical.gaming = {
    enable = lib.mkOption {
      default = false;
      description = ''
        Enable gaming applications.
      '';
    };
    enableKernelTweaks = lib.mkOption {
      default = cfg.enable || false;
      description = ''
        Enable kernel tweaks for gaming.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall =
      let
        # Taken from https://help.steampowered.com/en/faqs/view/2EA8-4D75-DA21-31EB
        steam-tcp-ports = [
          80 # HTTP
          443 # HTTPS
          27015 # RCON
        ];
        steam-tcp-port-ranges = [
          {
            # Basic
            from = 27050;
            to = 27105;
          }
        ];
        steam-udp-ports = [
          3478 # P2P & Voice
          4379 # P2P & Voice
          4380 # client & P2P & Voice
          27015 # gameplay traffic
        ];
        steam-udp-port-ranges = [
          {
            # Basic
            from = 27050;
            to = 27105;
          }
          {
            # Game Traffic
            from = 27000;
            to = 27100;
          }
          {
            # Remote Play
            from = 27031;
            to = 27036;
          }
          {
            # P2P & Voice
            from = 27014;
            to = 27030;
          }
        ];
      in
      {
        allowedTCPPorts = steam-tcp-ports;
        allowedTCPPortRanges = steam-tcp-port-ranges;
        allowedUDPPorts = steam-udp-ports;
        allowedUDPPortRanges = steam-udp-port-ranges;
      };

    # prevents steam from spamming logs by trying to start the upower service when it is disabled.
    services.dbus.packages = lib.mkIf (!config.services.upower.enable) [
      (pkgs.writeTextDir "etc/dbus-1/system.d/deny-upower.conf" ''
        <!DOCTYPE busconfig PUBLIC
           "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
           "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">

        <busconfig>
          <policy context="default">
            <deny own="org.freedesktop.UPower"/>
            <deny send_destination="org.freedesktop.UPower"/>
          </policy>
        </busconfig>
      '')
    ];
    programs = {
      steam = {
        enable = true;
        # Add packages required for Steam to launch gamescope
        package = pkgs.steam.override {
          extraPkgs =
            pkgs': with pkgs'; [
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib # Provides libstdc++.so.6
              libkrb5
              keyutils
              # Add other libraries as needed
            ];
        };
        #extest.enable = true; # Whether to enable Load the extest library into Steam, to translate X11 input events to uinput events (e.g. for using Steam Input on Wayland)
        # Extra packages to install for compatibility with Steam games
        extraCompatPackages = [
          pkgs.steamtinkerlaunch
        ];
        protontricks.enable = true; # Enable ProtonTricks
        #gamescopeSession = {
        #  enable = true;
        #};
      };
      gamescope = {
        enable = true;
        #package = pkgs.gamescope-wsi;
        #capSysNice = true;
        #args = [
        #  "--output-width"
        #  "2560"
        #  "--output-height"
        #  "1440"
        #  "--framerate-limit"
        #  "60"
        #  "--steam"
        #  "--hdr-enabled"
        #  "--hdr-itm-enable"
        #  "--prefer-output"
        #  "DP-1" # TODO make this dynamic
        #  "--prefer-vk-device"
        #  "1002:744c" # TODO make this dynamic
        #];
      };
      gamemode = {
        enable = true;
      };
    };

    #services = {
    #  input-remapper = {
    #    enable = true;
    #    enableUdevRules = true;
    #  };
    #};
    # Kernel tweaks based on SteamOS
    boot.kernel.sysctl = lib.mkIf cfg.enableKernelTweaks {
      # 20-shed.conf
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      # 20-net-timeout.conf
      # This is required due to some games being unable to reuse their TCP ports
      # if they're killed and restarted quickly - the default timeout is too large.
      "net.ipv4.tcp_fin_timeout" = 5;
      # 30-splitlock.conf
      # Prevents intentional slowdowns in case games experience split locks
      # This is valid for kernels v6.0+
      "kernel.split_lock_mitigate" = 0;
      # 30-vm.conf
      # USE MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
      # see comment in include/linux/mm.h in the kernel tree.
      "vm.max_map_count" = 2147483642;
    };
  };
}
