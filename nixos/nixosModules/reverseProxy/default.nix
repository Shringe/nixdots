
{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.reverseProxy;
in {
  imports = [
    ./acme.nix
    ./caddy.nix
    ./nginx.nix
  ];

  options.nixosModules.reverseProxy = {
    enable = mkEnableOption "Preferred reverse proxy setup";

    domain = mkOption {
      type = types.str;
      default = "deamicis.top";
    };

    aDomain = mkOption {
      type = types.str;
      default = "saria.top";
    };
  };

  config = mkIf cfg.enable {
    nixosModules.reverseProxy = {
      nginx.enable = mkDefault true;
      # caddy.enable = mkDefault true;
      acme.enable = mkDefault true;
    };
  };
}
