{ config, lib, pkgs, inputs, ... }:
with lib;
let
  cfg = config.nixosModules.maintenance.nix;
in {
  options.nixosModules.maintenance.nix = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enables maintenance and auto-updates on the nix store";
    };

    enableAutoUpgrade = mkOption {
      type = types.bool;
      default = true;
      description = "Auto updates for NixOS";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # Deprecated for now
      (writeShellApplication {
        name = "nix-maintenance";
        runtimeInputs = [
          # bash
        ];

        text = ''
          #!/usr/bin/env sh

          cd "$1"

          echo "Upating flake..."
          nix flake update
          echo "Upgrading system..."
          nixos-rebuild switch --flake .

          echo "Collecting garbage..."
          nix-collect-garbage --delete-older-than 30d
          echo "Optimising nix-store..."
          nix-store --optimise

          echo "Generating commit..."
          git add ./flake.lock
          git commit -m 'Automatic Update.'
        '';
      })
    ];

  #   systemd.services.nix-maintenance = {
  #     description = "nix-maintenance";
  #     after = [ "network.target" ];
  #     
  #     serviceConfig = {
  #       ExecStart = ''
  #         nix-maintenance ${inputs.self.outPath}
  #       '';
  #       Restart = "Never";
  #     };
  #
  #     wantedBy = [ "multi-user.target" ];
  #   };

    nix = {
      optimise = {
        automatic = true;
        dates = [ "weekly" ];
        randomizedDelaySec = "45min";
      };

      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
        randomizedDelaySec = "45min";
      };
    };

    system.autoUpgrade = mkIf cfg.enableAutoUpgrade {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-input"
        "nixpkgs"
        "--print-build-logs"
      ];

      dates = "weekly";
      randomizedDelaySec = "45min";
    };
  };
}
