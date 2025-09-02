{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.networking.wireless.wpa;
in
{
  options.nixosModules.networking.wireless.wpa = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets.wireless = { };

    networking.wireless = {
      enable = true;

      secretsFile = config.sops.secrets.wireless.path;
      networks = {
        "Kokiri_5G".pskRaw = "ext:home_pskRaw";
        "Kokiri_2G".pskRaw = "ext:home_pskRaw2";
      };
    };
  };
}
