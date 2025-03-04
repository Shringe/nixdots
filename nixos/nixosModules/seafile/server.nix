{ config, lib, pkgs, ... }:
### WIP
let
  # cfg = config.nixos
in {
  config = {
    services.seafile = {
      enable = false;

      adminEmail = "dashingkoso@gmail.com";
      initialAdminPassword = "123";

      # ccnetSettings.General.SERVICE_URL = "https://seafile.example.com";

      seafileSettings = {
        fileserver = {
          host = "unix:/run/seafile/server.sock";
        };
      };
    };
  };
}
