# { lib, config, ... }:
{
  imports = [
    ./zen
    ./firefox.nix
    ./chromium.nix
  ];

  options = {
  };
  # config = lib.mkIf config.browsers.default {
  #   browsers.firefox.enable = true;
  # };
}
