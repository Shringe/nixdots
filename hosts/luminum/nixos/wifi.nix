{
  networking.wireless = {
    enable = true;
    networks = {
      "TP-Link_76C0".pskRaw = "3e822d27defa5768c140227cfd2fa5ed0c9a76953d5395b7353c26d74f37cd06";  
      "VVISD_Guest".auth = "key_mgmt=NONE";
    };

    extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";

  
  };
  system.activationScripts.rfkillUnblockWlan = {
    text = "rfkill unblock wlan";
    deps = [];
  };
}
