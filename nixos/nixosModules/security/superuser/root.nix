{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.security.superuser.root;
in {
  options.nixosModules.security.superuser.root = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.security.superuser.enable;
    };
  };

  config = mkIf cfg.enable {
    # sops.secrets."user_passwords/root".neededForUsers = true;

    # users.users.root = {
      # hashedPasswordFile = config.sops.secrets."user_passwords/root".path;
      # openssh.authorizedKeys.keys = [
      #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4ApgoaedJkfYAoaNsK1Zx7EikM8mIwkUNpGnn/wU1W"
      # ];
    # };

    # Disable Root (Login) Entirely
    users.users.root.hashedPassword = "!";
  };
}
