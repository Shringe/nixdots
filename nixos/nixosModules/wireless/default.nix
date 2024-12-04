{ config, pkgs, lib, ... }:
let
  cfg = config.nixosModules.wireless;
in
{
  networking.wireless = lib.mkIf cfg.enable {
    enable = true;

    secretsFile = config.sops.secrets.wireless.path;
    networks = {
      "TP-Link_76C0".pskRaw = "ext:home_psk";  
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

