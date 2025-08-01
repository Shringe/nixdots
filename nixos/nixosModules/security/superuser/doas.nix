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

    useSudoRs = mkOption {
      type = types.bool;
      default = false;
      description = "If sudo is enabled, then use sudo-rs instead.";
    };
  };

  config = mkMerge [
    # Add users to wheel group only when doas is disabled
    (mkIf (!cfg.enable) {
      security = mkMerge [
        {
          doas.enable = mkForce false;
          please.enable = mkForce false;
        }

        (mkIf (!cfg.useSudoRs) {
          sudo.enable = mkForce true;
          sudo-rs.enable = mkForce false;
        })

        (mkIf cfg.useSudoRs {
          sudo.enable = mkForce false;
          sudo-rs.enable = mkForce true;
        })
      ];

      users.users = with config.nixosModules.users; mkMerge [
        (mkIf shringe.enable {
          shringe.extraGroups = [ "wheel" ];
        })
        (mkIf shringed.enable {
          shringed.extraGroups = [ "wheel" ];
        })
      ];
    })
    
    (mkIf cfg.enable {
      users = {
        # Allow NixOS configuration to build if no users are a part of the wheel group
        allowNoPasswordLogin = true;

        users = with config.nixosModules.users; mkMerge [
          (mkIf shringe.enable {
            # shringe.extraGroups = [ "systemd-journal" ];
          })
          (mkIf shringed.enable {
            shringed.extraGroups = [ "systemd-journal" ];
          })
        ];
      };

      security = {
        sudo.enable = mkForce false;
        sudo-rs.enable = mkForce false;
        please.enable = mkForce false;

        doas = {
          enable = mkForce true;

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
    })
  ];
}
