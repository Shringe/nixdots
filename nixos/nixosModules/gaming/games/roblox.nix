{
  inputs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.gaming.games.roblox;
in
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  options.nixosModules.gaming.games.roblox = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.gaming.games.enable;
    };
  };

  config = mkIf cfg.enable {
    services.flatpak = {
      enable = true;
      packages = [
        "org.vinegarhq.Sober"
      ];
    };
  };
}
