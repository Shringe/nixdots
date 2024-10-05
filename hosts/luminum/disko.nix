{
  disko.devices = {
    disk = {
      vda = {
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
            encryptedSwap = {
              size = "16G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };

            luks = {
              size = "100%";
              label = "luks";
              content = {
                type = "luks";
                name = "cryptroot";

                # https://0pointer.net/blog/unlocking-luks2-volumes-with-tpm2-fido2-pkcs11-security-hardware-on-systemd-248.html
                settings = {
                  allowDiscards = true;
                };
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
                    #"/@nix" = {
                    #  mountpoint = "/nix";
                    #  mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                    #};
                    #"/persist" = {
                    #  mountpoint = "/persist";
                    #  mountOptions = ["subvol=persist" "compress=zstd" "noatime"];
                    #};
                    "/_active/log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["subvol=/_active/log" "compress=zstd" "noatime"];
                    };
                    #"/swap" = {
                    #  mountpoint = "/swap";
                    #  swap.swapfile.size = "4g";
                    #};
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

