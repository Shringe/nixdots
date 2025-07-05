{ config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.security.superuser.doas;
in {
  options.nixosModules.security.superuser.doas = {
    enable = mkOption {
      type = types.bool;
      # default = config.nixosModules.security.superuser.enable;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    # Allow NixOS configuration to build if no users are a part of the wheel group
    users.allowNoPasswordLogin = true;

    security = {
      sudo.enable = false;

      doas = {
        enable = true;

        extraRules = with config.nixosModules.users; [
          {
            users = []
              ++ optionals shringe.enable [ "shringe" ]
              ++ optionals shringed.enable [ "shringed" ];

            # keepEnv = true;
            # persist = true;
          }
        ];
      };
    };
  };
}
