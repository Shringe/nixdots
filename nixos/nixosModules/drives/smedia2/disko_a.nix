let
  drive = "smedia2";
in {
  disko.devices.disk.${drive} = {
    type = "disk";
    device = "/dev/disk/by-id/wwn-0x5000c500b54fb2c0";
    content = {
      type = "luks";
      name = "${drive}a_crypt";

      passwordFile = "/run/secrets/disks/${drive}";

      content = {
        type = "btrfs";
        extraArgs = [ "-f" "-L" drive ];

        subvolumes = {
          "_active" = {};
          "_active/critical" = {};
          "_active/local" = {};
          "_active/backups" = {};
          "_snapshots" = {};
        };
      };
    };
  };
}
