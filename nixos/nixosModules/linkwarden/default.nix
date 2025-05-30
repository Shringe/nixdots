{ config, lib, pkgs, ... }:
with lib;
let 
  cfg = config.nixosModules.linkwarden;
in {
  imports = [
    ./module.nix
  ];

  options.nixosModules.linkwarden = {
    enable = mkEnableOption "linkwarden";

    port = mkOption {
      type = types.port;
      default = 41040;
    };

    description = mkOption {
      type = types.string;
      default = "Fancy Bookmark Manager";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://linkwarden.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "linkwarden.png";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "linkwarden" = { owner = "linkwarden"; };
    };

    services.linkwarden = {
      enable = true;
      package = (pkgs.callPackage ../../../shared/packages/linkwarden.nix {});
      host = config.nixosModules.info.system.ips.local;
      port = cfg.port;
      secretsFile = config.sops.secrets."linkwarden".path;

      enableRegistration = true;
    };
  };
}
