{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.kavita;
in
{
  options.nixosModules.kavita = {
    enable = mkEnableOption "Kavita ebook manager";

    host = mkOption {
      type = types.string;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 47360;
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://kavita.${config.nixosModules.reverseProxy.domain}";
    };

    description = mkOption {
      type = types.string;
      default = "Ebook and Comics Manager";
    };

    icon = mkOption {
      type = types.string;
      default = "kavita.svg";
    };

    directory = mkOption {
      type = types.string;
      default = "/mnt/server/local/kavita";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."kavita" = { };

    users.users.kavita.extraGroups = [
      "manga"
      "books"
    ];

    services.kavita = {
      enable = true;
      tokenKeyFile = config.sops.secrets."kavita".path;
      dataDir = cfg.directory;

      settings = {
        Port = cfg.port;
      };
    };
  };
}
