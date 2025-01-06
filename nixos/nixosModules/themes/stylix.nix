{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.nixosModules.themes.stylix;
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = lib.mkIf cfg.enable {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
  };
}
