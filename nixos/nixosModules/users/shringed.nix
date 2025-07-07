{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.users.shringed;
in {
  config = mkIf cfg.enable {
    sops.secrets."user_passwords/shringed".neededForUsers = true;

    users.users.shringed = {
      isNormalUser = true;
      extraGroups = [ "audio" "nixdots" "steam" "nordvpn" "gamemode" "adbusers" "systemd-journal" ];
      hashedPasswordFile = config.sops.secrets."user_passwords/shringed".path;

      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFhNGAfMh9PgOkAZjKvp9QBiydu+Vjf/Iudrz8cf0e+t/6SGz3UdmoaAlaCwSnXWp3Z65pRyXpy7IpbwHVKTkVI= u0_a311@localhost"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBoXN524KYJg+H+ppKIRcxbl9Dsw5xS1tka3bm6CYXM645vS8ygtIjM/sEe/TCozYybpdS8WkYM4aO71mwR4MaU= valleyviewisd\logen.deamicis@VVISD-HS110-12"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBB76+sFPiP18BEvVLV9PuqBi3YcTdA25iVzJlBjA955SNCAQoXI77+ROi6gvAv/FQcLwQYjDbrbkSqhIwsB2ncg= shringed@deity"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNr7Xah23Lwa8gP7a7KtQ9yl0QrX7WmMVABQyMCtmb6yFFHwvH+YwGoHU3TbpcG+wkhDe+zB8f65LmT9v+0QwVE= valleyviewisd\logen.deamicis@vvisd8"
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDGefNxf4vwUAIVjG2tohE37iIssn1k9dq5k7t/bM9kHmVL1qo+Juduvzt2RWq8ExFOJ6l6ro1z3vDYSQ62f5+C9ZXr3t/ujgURLwyAYDxFPxK04WbL3YJgX7mxUA7bVCa3+s+9EEO5oFr6vedsJQqHMMcsnyl12ZUwomnjhAu49BIWwag/kOpP6FC0RpzG/t0EnocSVTfTxcSZB3BuQkMRVUHBofHB95+XReWzIoo+fz0APq9u35SJhcwT2n5AKx8HWgpBvPkiFtsAe5Vl5FwJcvEXSsVBIjdx+Gua1Cy+m8tRLl3gzocWrZVITxWUIn23CDTtH6+009mQmUQjoJszMhlI3AODPWXbkd+PRYdVBhha5NA1oQqvfs+F0hhIm6ns1dMXpQooberkI0EUC4NB7M63+QxCXp4cBP0vk1pbsEgNFyMEcpVUUkxV7z22mATqaebCKDzE2ZU9j1nBiOS8j2RjMXakn2OUqwfMCnFPhbutn5g/fazaH4bovI1gSw8= thechosenone@DESKTOP-PIJU486"
      ];
    };

    # services.udev.extraRules = ''SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"'';
  };
}
