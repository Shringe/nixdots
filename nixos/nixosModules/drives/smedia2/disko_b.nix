let
  drive = "smedia2";
in
{
  disko.devices.disk.${drive} = {
    type = "disk";
    device = "/dev/disk/by-id/ata-HGST_HUH721010ALE604_2THR6S4D";
    content = {
      type = "luks";
      name = "${drive}b_crypt";

      passwordFile = "/run/secrets/disks/${drive}";

      content = {
        type = "btrfs";
        extraArgs = [
          "-f"
        ];
      };
    };
  };
}
