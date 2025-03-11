{ config, lib, ... }:
let
  cfg = config.nixosModules.users.shringed;
in
{
  sops.secrets."user_passwords/shringed".neededForUsers = true;
  users.users.shringed = lib.mkIf cfg.enable {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "nixdots" "steam" "nordvpn" "docker" ];
    hashedPasswordFile = config.sops.secrets."user_passwords/shringed".path;
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFhNGAfMh9PgOkAZjKvp9QBiydu+Vjf/Iudrz8cf0e+t/6SGz3UdmoaAlaCwSnXWp3Z65pRyXpy7IpbwHVKTkVI= u0_a311@localhost"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBoXN524KYJg+H+ppKIRcxbl9Dsw5xS1tka3bm6CYXM645vS8ygtIjM/sEe/TCozYybpdS8WkYM4aO71mwR4MaU= valleyviewisd\logen.deamicis@VVISD-HS110-12"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBB76+sFPiP18BEvVLV9PuqBi3YcTdA25iVzJlBjA955SNCAQoXI77+ROi6gvAv/FQcLwQYjDbrbkSqhIwsB2ncg= shringed@deity"
    ];
  };

  services.udev.extraRules = ''SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"'';
}
