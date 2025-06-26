{ lib, config, inputs, ...}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = lib.mkIf config.homeManagerModules.sops.enable {
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets.yaml;

    secrets = {

    };
  };
}
