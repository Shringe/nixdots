{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.arrs;
in
{
  imports = [
    ./lidarr.nix
    ./sonarr.nix
    ./prowlarr.nix
    ./radarr.nix
  ];

  config = mkIf cfg.enable {
    users.users.jsparrow = {
      isSystemUser = true;
      initialPassword = "123";
    };
  };
}
