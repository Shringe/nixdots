{ config, ... }:
{
  imports = [
    ./shringe.nix
    ./shringed.nix
  ];


  sops.secrets."user_passwords/root".neededForUsers = true;
  users = {
    mutableUsers = true;

    groups = {
      nixdots = {};
      steam = {};
    };

    users.root = {
      hashedPasswordFile = config.sops.secrets."user_passwords/root".path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4ApgoaedJkfYAoaNsK1Zx7EikM8mIwkUNpGnn/wU1W"
      ];
    };
  };
}
