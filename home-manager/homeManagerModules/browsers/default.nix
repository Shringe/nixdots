{ lib, config, ... }:
{
  imports = [
    ./firefox.nix
  ];

  options = {
    browsers.default = lib.mkEnableOption "Enables preferred browser module";
  };
  config = lib.mkIf config.browsers.default {
    browsers.firefox.enable = true;
  };
}
