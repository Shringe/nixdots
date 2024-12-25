{ config, ... }:
{
  sops.secrets."user_passwords/shringe".neededForUsers = true;

  users = {
    mutableUsers = false;

    groups = {
      nixdots = {};
    };
    
    users = {
      shringe = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "audio" "nixdots" ];
        hashedPasswordFile = config.sops.secrets."user_passwords/shringe".path;
      };
    };
  };
}
