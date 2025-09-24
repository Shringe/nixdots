{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.networking.wireless.iwd;
in
{
  options.nixosModules.networking.wireless.iwd = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.networking.wireless.enable;
    };
  };

  config = mkIf cfg.enable {
    # services.resolved.enable = true;
    networking.wireless.iwd = {
      enable = true;
      settings = {
        Settings = {
          AutoConnect = true;
          AlwaysRandomizeAddress = true;
        };

        General = {
          AddressRandomization = "network";
          # EnableNetworkConfiguration = true;
        };
      };
    };
  };
}
