{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.adblock.adguard;
in {
  options.nixosModules.adblock.adguard = {
    enable = mkEnableOption "Adguard dns";

    ports = {
      webui = mkOption {
        type = types.port;
        default = 47120;
      };
      dns = mkOption {
        type = types.port;
        default = 47100;
      };
    };

    dns = mkOption {
      type = types.string;
      default = "192.168.0.165";
    };

    host = mkOption {
      type = types.string;
      default = "0.0.0.0";
    };
  };

  config = mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      port = cfg.ports.webui;
      host = cfg.host;

      settings = {
        dns = {
          upstream_dns = [
            "1.0.0.1"
            "8.8.8.8"
            "9.9.9.9"
          ];
        };

        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
        };

        filters = map(url: { enabled = true; url = url; }) [
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_18.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_24.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_30.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_44.txt" # fix
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_50.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_51.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_53.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_54.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_55.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_56.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_61.txt"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.ports.webui ];
    networking.firewall.allowedUDPPorts = [ 53 ];
  };
}
