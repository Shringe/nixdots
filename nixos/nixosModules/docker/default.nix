{ config, lib, pkgs, ... }:
let
  cfg = config.nixosModules.docker;
in {
  imports = [
    ./automaticrippingmachine
    ./romm
    ./ourshoppinglist
    ./wallos
  ];

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";
      autoPrune.enable = true;
    };

    virtualisation.oci-containers.backend = "docker";
  };
}
