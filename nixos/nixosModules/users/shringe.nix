{ config, lib, ... }:
let
  cfg = config.nixosModules.users.shringe;
in
{
  # sops.secrets."user_passwords/shringe".neededForUsers = lib.mkIf cfg.enable true;
  users.users.shringe = lib.mkIf cfg.enable {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "nixdots" ];
    initialPassword = "123";
    # hashedPasswordFile = config.sops.secrets."user_passwords/shringe".path;
  };
}
