{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.samba;
in
{
  options.nixosModules.server.services.samba = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    directory = mkOption {
      type = types.str;
      default = "/mnt/server/local/samba";
    };
  };

  config = mkIf cfg.enable {
    users.users.samba-share = {
      isSystemUser = true;
      group = "samba-share";
    };

    users.groups.samba-share = { };

    systemd.tmpfiles.rules = [
      "d ${cfg.directory} 0750 ${config.users.users.samba-share.name} ${config.users.users.samba-share.group} -"
    ];

    services.samba = {
      enable = true;
      package = pkgs.samba4Full;
      openFirewall = true;

      settings = {
        global = {
          # "workgroup" = "WORKGROUP";
          "server string" = "Deity";
          # "security" = "user";
          # "guest account" = "nobody";
          "map to guest" = "Bad User";
        };

        "guest" = {
          "path" = cfg.directory;
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0650";
          "directory mask" = "0750";
          "force user" = config.users.users.samba-share.name;
          "force group" = config.users.users.samba-share.group;
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
      interface = "eno1";
    };
  };
}
