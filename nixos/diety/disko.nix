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
              label = "boot";
              name = "ESP";
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };

            swap = {
              size = "40G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };

	    root = {
	      size = "100%";
	      content = {
                type = "btrfs";
                extraArgs = ["-L" "nixos" "-f"];
                subvolumes = {
                  "/_active/@" = {
                    mountpoint = "/";
                    mountOptions = ["subvol=/_active/@" "compress=zstd" "noatime"];
                  };
                  "/_active/@home" = {
                    mountpoint = "/home";
                    mountOptions = ["subvol=/_active/@home" "compress=zstd" "noatime"];
                  };
                  "/_active/@nix" = {
                   mountpoint = "/nix";
                   mountOptions = ["subvol=/_active/@nix" "compress=zstd" "noatime"];
                  };
                  "/_active/log" = {
                    mountpoint = "/var/log";
                    mountOptions = ["subvol=/_active/log" "compress=zstd" "noatime"];
                  };
                };
	      };
            };
          };
        };
      };
    };
  };

  fileSystems."/var/log".neededForBoot = true;
}

