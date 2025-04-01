{
  lib,
  pkgs,
  config,
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
    environment.systemPackages = with pkgs; [
      steam-run
      protonup-qt
      mangohud
      nvtopPackages.full
      goverlay
      (prismlauncher.override {
        jdks = [
          jdk8
          jdk17
          jdk21
        ];
      })
      (r2modman.overrideAttrs (
        let
          src = pkgs.fetchFromGitHub {
            owner = "ebkr";
            repo = "r2modmanPlus";
            rev = "59c1fe5287593eb58b4ce6d5d8f2ca59ca64bfd4";
            hash = "sha256-1b24tclqXGx85BGFYL9cbthLScVWau2OmRh9YElfCLs=";
          };
        in
        {
          inherit src;
          offlineCache = pkgs.fetchYarnDeps {
            yarnLock = "${src}/yarn.lock";
            hash = "sha256-3SMvUx+TwUmOur/50HDLWt0EayY5tst4YANWIlXdiPQ=";
          };
        }
      ))
    ];

    programs = {
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers.
        extest.enable = true; # Whether to enable Load the extest library into Steam, to translate X11 input events to uinput events (e.g. for using Steam Input on Wayland)
        # Extra packages to install for compatibility with Steam games
        extraCompatPackages = [
          pkgs.proton-ge-bin
        ];
        protontricks.enable = true; # Enable ProtonTricks
        gamescopeSession = {
          enable = true;
          args = [
            "--output-width"
            "3840"
            "--output-height"
            "2160"
            "--framerate-limit"
            "60"
            "--steam"
            "--hdr-enabled"
            "--hdr-itm-enable"
            "--prefer-output"
            "DP-1" # TODO make this dynamic
            "--prefer-vk-device"
            "1002:744c" # TODO make this dynamic
          ];
        };
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      gamemode = {
        enable = true;
      };
    };

    services = {
      input-remapper = {
        enable = true;
        enableUdevRules = true;
      };
    };
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
