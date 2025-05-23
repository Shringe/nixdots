{ inputs, lib, config, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets.yaml;
    # validateSopsFiles = false;

    age = {
      # sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      sshKeyPaths = [ ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets = {
      # "user_passwords/shringe" = {};
    };
  };
}
