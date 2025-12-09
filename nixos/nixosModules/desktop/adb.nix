{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.desktop.adb;
in
{
  options.nixosModules.desktop.adb = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.desktop.enable;
    };

    port = mkOption {
      type = types.int;
      default = 12037;
      description = "Port for adb server to use";
    };
  };

  config = mkIf cfg.enable {
    users.groups.adbusers.members =
      with config.nixosModules.users;
      optionals shringe.enable [ "shringe" ] ++ optionals shringed.enable [ "shringed" ];

    programs.adb.enable = true;

    environment = {
      sessionVariables = {
        ANDROID_ADB_SERVER_PORT = cfg.port;
      };

      systemPackages = with pkgs; [
        scrcpy
        universal-android-debloater
      ];
    };
  };
}
