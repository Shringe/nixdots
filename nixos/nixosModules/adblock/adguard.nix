{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.adblock.adguard;

  # Creates a custom filtering name for the reverse proxy
  rp = subDomain: "${config.nixosModules.info.system.ips.local} ${subDomain}.${config.nixosModules.reverseProxy.domain}";
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
      default = config.nixosModules.info.system.ips.local;
    };

    host = mkOption {
      type = types.string;
      default = "0.0.0.0";
    };

    description = mkOption {
      type = types.string;
      default = "Network-Wide Ad Blocker";
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.dns}:${toString cfg.ports.webui}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://adguard.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      # default = "adguard-home.svg";
      default = "apps-adguard.svg";
    };
  };

  config = mkIf cfg.enable {
    services.adguardhome = {
      enable = true;
      port = cfg.ports.webui;
      host = cfg.host;
      mutableSettings = false;

      settings = {
        dns = {
          upstream_dns = [
            "https://dns.quad9.net/dns-query"
            "tls://dns.quad9.net"
          ];

          # fallback_dns = [
          #   "8.8.8.8"
          #   "9.9.9.9"
          # ];

          bootstrap_dns = [
            "9.9.9.9"
            "149.112.112.112"
          ];

          # Disables ipv6
          aaaa_disabled = true;

          upstream_mode = "parallel";
          cache_optimistic = true;
          ratelimit = 0;
          enable_dnssec = true;
          anonymize_client_ip = true;
        };

        querylog = {
          enabled = true;
          interval = "6h";
        };

        statistics = {
          enabled = true;
          interval = "6h";
        };

        user_rules = [
          (rp "jellyfin")
          (rp "tandoor")
          (rp "dash")
          (rp "kavita")
          (rp "jellyseerr")
          (rp "gatus")
          (rp "adguard")
          (rp "immich")
          (rp "radicale")
          (rp "ollama")
          (rp "router")
          (rp "lidarr")
          (rp "radarr")
          (rp "sonarr")
          (rp "prowlarr")
          (rp "torrent")
          (rp "auth")
          (rp "flaresolverr")
          (rp "atuin")
          (rp "romm")
          (rp "linkwarden")
          (rp "ourshoppinglist")
          (rp "traccar")
          (rp "nextcloud")
          (rp "wallos")
        ];

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
          # "https://adguardteam.github.io/HostlistsRegistry/assets/filter_56.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_59.txt"
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_61.txt"
        ];
      };
    };

    networking.firewall.allowedUDPPorts = [ 53 ];
  };
}
