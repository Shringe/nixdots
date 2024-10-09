{ config, ... }:
{
  networking.wireless = {
    enable = true;

    secretsFile = config.age.secrets.wireless.path;
    networks = {
      "TP-Link_76C0".pskRaw = "ext:home";  
    };
  };

  system.activationScripts.rfkillUnblockWlan = {
    text = "rfkill unblock wlan";
    deps = [];
  };
}

