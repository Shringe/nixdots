{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.desktop.adb;
in
{
  options.nixosModules.desktop.adb = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.groups.adbusers.members =
      with config.nixosModules.users;
      optionals shringe.enable [ "shringe" ] ++ optionals shringed.enable [ "shringed" ];

    programs.adb.enable = true;
  };
}
