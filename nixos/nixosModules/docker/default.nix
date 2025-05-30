{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.docker;
in {
  imports = [
    ./automaticrippingmachine
    ./romm
  ];

  # Depricated
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
