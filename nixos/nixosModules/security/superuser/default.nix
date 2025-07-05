{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.security.superuser;
in {
  imports = [
    ./doas.nix
    ./root.nix
  ];

  options.nixosModules.security.superuser = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.security.enable;
    };
  };
}
