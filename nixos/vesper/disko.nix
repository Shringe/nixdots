{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda1";

        content = {
          type = "gpt";

          partitions = {
            ESP = {
	      priority = 1;
              # label = "boot";
              name = "ESP";
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "umask=0077"
                ];
              };
            };

            # swap = {
            #   size = "40G";
            #   content = {
            #     type = "swap";
            #     resumeDevice = true;
            #   };
            # };

	    root = {
	      size = "100%";
	      content = {
                type = "btrfs";
                extraArgs = [ "-L" "nixos" "-f" ];
                subvolumes = {
                  "/_active/@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/_active/@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/_active/@nix" = {
                   mountpoint = "/nix";
                   mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/_active/log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "noatime" ];
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

