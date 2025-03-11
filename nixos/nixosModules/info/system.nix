{ lib, ... }:
with lib;
{
  options.nixosModules.info.system = {
    ips = {
      local = mkOption {
        type = types.string;
      };
      
      public = mkOption {
        type = types.string;
        default = "66.208.98.226";
      };
    };
  };
}
