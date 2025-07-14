{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.wireguard.server.peers;

  key = {
    sopsFile = ./secrets.yaml;
  };

  mkPeer = num: name: public: {
    publicKey = public;
    allowedIPs = [ "${cfg.private_ip}.${toString num}/32" ];
    presharedKeyFile = config.sops.secrets."preshared/${name}".path;
  };
in {
  options.nixosModules.wireguard.server.peers = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.wireguard.server.enable;
    };

    private_ip = mkOption {
      type = types.string;
      default = config.nixosModules.wireguard.server.private_ip;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "preshared/L_Phone" = key;
      "preshared/K_Phone" = key;
      "preshared/K_Laptop" = key;
    };

    networking.wireguard.interfaces.wg0.peers = [
      # { # K Phone
      #   publicKey = "3HSS1loEZSCGjfqOLm/dyZpPfwzT31wKvw8Ygrl5czE=";
      #   allowedIPs = [ "${cfg.private_ip}.3/32" ];
      # }
      (mkPeer 2 "L_Phone" "5PfQalJfIoZwTCD7pjamN1PjsqC4V7wWfg0M1kIvqUo=")
      (mkPeer 3 "K_Phone" "XbbfzMbue9NF7QjJpi68w3SciQJGZq954X9aZtoXb0s=")
      (mkPeer 4 "K_Laptop" "t+CZw/W6/7G8PTxUiYn9C6lqwak1OFfTRvGU0YTb9UM=")
    ];
  };
}
