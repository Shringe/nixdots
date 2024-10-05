{ config, ... }:
{
  sops.secrets."wireless" = {};
  networking.wireless = {
    enable = true;

    secretsFile = config.sops.secrets."wireless".path;
    networks = {
      "TP-Link_76C0".pskRaw = "ext:home_pass";  
    };
  };

  system.activationScripts.rfkillUnblockWlan = {
    text = "rfkill unblock wlan";
    deps = [];
  };
}

