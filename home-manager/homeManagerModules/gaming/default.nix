{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.gaming;
in
{
  imports = [
    ./mangohud
    ./recording.nix
  ];

  options.homeManagerModules.gaming = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable gaming related tools and configurations.";
    };
  };

  config = mkIf cfg.enable {
    # Look for desktop files of system flatpaks
    xdg.systemDirs.data = [
      "/var/lib/flatpak/exports/share"
    ];
  };
}
