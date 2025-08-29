{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nixosModules.wireless;
in
{
  sops.secrets.wireless = lib.mkIf cfg.enable { };

  networking.wireless = lib.mkIf cfg.enable {
    enable = true;

    secretsFile = config.sops.secrets.wireless.path;
    networks = {
      "Kokiri_5G".pskRaw = "ext:home_pskRaw";
      "Kokiri_2G".pskRaw = "ext:home_pskRaw2";
    };
  };

  systemd.services.rfkillUnblockWlan = lib.mkIf cfg.fixes.unblockWlan.enable {
    description = "unblocks wlan";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock wlan";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };
}
