{ lib, ... }:
with lib;
{
  options.nixosModules.info.system = {
    ips = {
      local = mkOption {
        type = types.string;
      };
    };
  };
}
