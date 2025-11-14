{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.users.shringe;
in
{
  config = mkIf cfg.enable {
    sops.secrets."user_passwords/shringe".neededForUsers = true;

    users.users.shringe = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "audio"
        "nixdots"
        "nordvpn"
      ];
      shell = pkgs.nushell;
      hashedPasswordFile = config.sops.secrets."user_passwords/shringe".path;
    };
  };
}
