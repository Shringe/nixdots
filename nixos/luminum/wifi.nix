{ config, pkgs, ... }:
{
  networking.wireless = {
    enable = true;

    secretsFile = config.sops.secrets.wireless.path;
    networks = {
      "TP-Link_76C0".pskRaw = "ext:home_psk";  
    };
    # secretsFile = config.age.secrets.wireless.path;
    # networks = {
    #   "TP-Link_76C0".pskRaw = "ext:home";  
    # };
  };

  # system.activationScripts.rfkillUnblockWlan = {
  #   text = ''
  #     rfkill unblock wlan > /tmp/unblockwlan.txt
  #   '';
  #   deps = [];
  # };

  systemd.services.rfkillUnblockWlan = {
    description = "unblocks wlan";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock wlan";
      RemainAfterExit = true;
    };
    wantedBy = [ "multi-user.target" ];
  };
}

