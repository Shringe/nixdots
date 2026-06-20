{ config, lib, ... }:
let
  cfg = config.nixosModules.server.services.minecraft;
in
{
  imports = [
    ./school3.nix
    ./meatballcraft.nix
  ];

  options.nixosModules.server.services.minecraft = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.nixosModules.server.services.enable;
    };

    directory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/minecraft";
      description = "The parent directory where all minecraft servers will be stored under";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "minecraft";
      description = "The name of the group to hold the parent directory";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d ${cfg.directory} 0710 root ${cfg.group} -"
    ];

    users.groups.${cfg.group} = { };
  };
}
