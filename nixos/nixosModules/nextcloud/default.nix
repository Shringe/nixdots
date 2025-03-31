{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.nextcloud;
in {
  options.nixosModules.nextcloud = {
    enable = mkEnableOption "Nextcloud hosting";
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "nextcloud/passwords/admin" = {};
    };

    services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud29;
      hostName = "localhost";
      config.adminpassFile = config.sops.secrets."nextcloud/passwords/admin".path;
      config.dbtype = "sqlite";
    };
  };
}
