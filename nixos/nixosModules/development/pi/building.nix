{ lib, config, ... }:
let
  cfg = config.nixosModules.development.pi.building;
in
{
  boot.binfmt.emulatedSystems = lib.mkIf cfg.enable [ "aarch64-linux" ];

  nixpkgs.config.allowUnsupportedSystem = true;
}
