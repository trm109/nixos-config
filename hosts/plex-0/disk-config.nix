# copy this to /tmp/disk-config.nix
# modify to match device.
# run:
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disk-config.nix
# check if worked:
# mount | grep /mnt
# run:
# sudo nixos-generate-config --root /mnt
# copy disk-config.nix for posterity:
# sudo mv /tmp/disk-config.nix /mnt/etc/nixos/
# Install:
# sudo nixos-install
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "ESP";
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # Override existing partition
                # Subvolumes must set a mountpoint in order to be mounted,
                # unless their parent is mounted
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "/rootfs" = {
                    mountpoint = "/";
                  };
                  # Subvolume name is the same as the mountpoint
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
                  };
                  # Parent is not mounted so the mountpoint must be set
                  "/nix" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                  # Subvolume for the swapfile
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap = {
                      swapfile.size = "20M";
                      swapfile2.size = "20M";
                      swapfile2.path = "rel-path";
                    };
                  };
                };

                mountpoint = "/partition-root";
                swap = {
                  swapfile = {
                    size = "20M";
                  };
                  swapfile1 = {
                    size = "20M";
                  };
                };
              };
            };
          };
        };
      };
      data = {
        type = "disk";
        device = "/dev/sda";
        content = {
        	type = "gpt";
  	partitions = {
  	  storage = {
  	    size = "100%";
  	    content = {
  	      type = "btrfs";
  	      extraArgs = [ "-f" ];
  	      subvolumes = {
  	        "/storage" = {
  		  mountOptions = [ "compress=zstd" "noatime" ];
  		  mountpoint = "/storage";
  		};
  	      };
  	    };
  	  };
  	};
        };
      };
    };
  };
}
