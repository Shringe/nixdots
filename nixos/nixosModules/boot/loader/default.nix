{ lib, config, ... }:
with lib;
{
  imports = [
    ./grub.nix
    ./systemd-boot.nix
  ];

  options.nixosModules.boot.loader = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.boot.enable;
    };

    config = mkIf cfg.enable {
      boot.loader = {
        timeout = 0;
      };
    };
  };
}
