{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.networking.wireless.networkmanager;
in
{
  options.nixosModules.networking.wireless.networkmanager = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    users.groups.networkmanager.members =
      with config.nixosModules.users;
      optionals shringe.enable [ "shringe" ] ++ optionals shringed.enable [ "shringed" ];

    networking = {
      # wireless.enable = true;
      networkmanager = {
        enable = true;
        wifi.powersave = true;
      };
    };

    environment.systemPackages = with pkgs; [
      networkmanagerapplet
    ];
  };
}
