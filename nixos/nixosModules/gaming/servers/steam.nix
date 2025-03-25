{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.gaming.servers.steam;
in {
  options.nixosModules.gaming.servers.steam = {
    enable = mkEnableOption "Sets up steam user for SteamCMD servers";

    uid = mkOption {
      type = types.int;
      default = 7777;
    };

    gid = mkOption {
      type = types.int;
      default = 7777;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."user_passwords/steam".neededForUsers = true;

    environment.systemPackages = with pkgs; [
      steamcmd
    ];

    users = {
      groups.steam = {
        gid = cfg.gid;
      };

      users.steam = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets."user_passwords/steam".path;
        group = "steam";
        extraGroups = [ "docker" ];
        uid = cfg.uid;
      };
    };
  };
}
