{ config, ... }:
{
  imports = [
    ./shringe.nix
    ./shringed.nix
  ];

  users = {
    mutableUsers = true;

    groups = {
      nixdots = {};
      steam = {};
    };
  };
}
