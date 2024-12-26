{ config, lib, ... }:
let
  cfg = config.nixosModules.users.shringed;
in
{
  sops.secrets."user_passwords/shringed".neededForUsers = lib.mkIf cfg.enable true;
  users.users.shringed = lib.mkIf cfg.enable {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "nixdots" ];
    hashedPasswordFile = config.sops.secrets."user_passwords/shringed".path;
  };
}
