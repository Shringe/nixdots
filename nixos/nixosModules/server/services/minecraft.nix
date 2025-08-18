{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.minecraft;

  domain = config.nixosModules.reverseProxy.domain;
in
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options.nixosModules.server.services.minecraft = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    host = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
    };

    port = mkOption {
      type = types.port;
      default = 47480;
    };

    url = mkOption {
      type = types.string;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://mc.${domain}";
    };
  };

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;

      servers.school = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21_8;

        symlinks."mods" = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Lithium = pkgs.fetchurl {
              url = "https://modrinth.com/mod/lithium/version/mc1.21.8-0.18.0-fabric";
              hash = "sha256-UV2nAJPgHx0+nIZ1FJvBrzxM6O4KzPkEbaP+20BMeWI=";
            };
          }
        );

        serverProperties = {
          server-port = cfg.port;
          difficulty = "hard";
          gamemode = "survival";
          max-players = 8;
          motd = "School minecraft-server test!";
        };
      };
    };
  };
}
