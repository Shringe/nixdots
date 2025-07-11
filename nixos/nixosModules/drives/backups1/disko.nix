let
  drive = "backups1";
in {
  disko.devices.disk.${drive} = {
    type = "disk";
    device = "/dev/disk/by-id/wwn-0x50014ee2bd75d292";
    content = {
      type = "luks";
      name = "${drive}_crypt";

      # You'll be prompted for password during setup
      passwordFile = "/run/secrets/disks/${drive}"; # Optional: path to password file

      content = {
        type = "btrfs";
        extraArgs = [ "-f" "-L" drive ];

        subvolumes = {
          "smedia1" = {};
        };
      };
    };
  };
}
