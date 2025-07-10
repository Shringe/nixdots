{ config, lib, ... }:
with lib;
{
  imports = [
    ./qtile.nix
    ./hyprland.nix
    ./sway.nix
    ./dwl.nix
  ];

  options.nixosModules.desktop.windowManagers = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.desktop.enable;
      description = "Enable prefferd window manager(s).";
    };
  };
}
