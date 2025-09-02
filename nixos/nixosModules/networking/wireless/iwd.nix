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
    networking.wireless.iwd = {
      enable = true;
      settings = {
        Settings = {
          AutoConnect = true;

          # TODO, I don't think this is working
          AlwaysRandomizeAddress = true;
        };
      };
    };
  };
}
