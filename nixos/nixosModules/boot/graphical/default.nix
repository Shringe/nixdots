{ config, lib, ... }:
with lib;
{
  imports = [
    ./ly.nix
    ./lightdm.nix
    ./regreet.nix
    ./plymouth.nix
    ./sddm.nix
    ./gdm.nix
  ];

  options.nixosModules.boot.graphical = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.boot.enable && config.nixosModules.desktop.enable;
    };
  };
}
