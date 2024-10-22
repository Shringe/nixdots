{ lib, config, ... }:
{
  imports = [
    ./firefox.nix
  ];

  options = {
  };
  # config = lib.mkIf config.browsers.default {
  #   browsers.firefox.enable = true;
  # };
}
