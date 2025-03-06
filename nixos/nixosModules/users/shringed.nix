{ config, lib, ... }:
let
  cfg = config.nixosModules.users.shringed;
in
{
  # sops.secrets."user_passwords/shringed".neededForUsers = true;
  users.users.shringed = lib.mkIf cfg.enable {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "nixdots" "steam" "nordvpn" "docker" ];
    initialPassword = "123";
    # hashedPasswordFile = config.sops.secrets."user_passwords/shringed".path;
  };

  services.udev.extraRules = ''SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"'';
}
