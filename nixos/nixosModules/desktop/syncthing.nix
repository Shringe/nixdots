{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.desktop.syncthing;
in
{
  options.nixosModules.desktop.syncthing = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    user = mkOption {
      type = types.str;
      description = "Needed so that paths can correctly sync across paths relative to $HOME";
    };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = cfg.user;
      dataDir = "/home/${cfg.user}";
      # openDefaultPorts = true;

      settings = {
        devices = {
          "deity" = {
            id = "5W7H7GU-TDU26JX-B4MFEOZ-GJ32I2H-WYJCLTO-6XAQKFP-JFL7FJZ-H4WGBQE";
          };

          "luminum" = {
            id = "JI7RPB6-XTF62TE-A55VBEV-UT62TH6-TU5GG45-Q7W6R5U-NW3PMOO-PEEQKAJ";
          };
        };

        folders = {
          "Documents" = {
            path = "~/Documents";
            devices = [
              "deity"
              "luminum"
            ];
          };
        };
      };
    };
  };
}
