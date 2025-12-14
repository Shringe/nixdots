{
  lib,
  inputs,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.gaming.optimizations;
in
{
  imports = with inputs.nix-gaming.nixosModules; [
    pipewireLowLatency
    platformOptimizations
  ];

  options.nixosModules.gaming.optimizations = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.gaming.enable;
    };

    conservePower = mkOption {
      type = types.bool;
      default = true;
      description = "Disables extra optimizations that that may result in increased power consumption.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (!cfg.conservePower) {
      services.pipewire.lowLatency.enable = true;

      # make pipewire realtime-capable
      security.rtkit.enable = true;

      boot.kernelParams = [
        "usbcore.autosuspend=60"
      ];
    })

    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      # SteamOS platform optimizations
      programs.steam.platformOptimizations.enable = true;

      boot.kernel.sysctl = {
        "vm.swappiness" = 20;
      };

      boot = {
        tmp.useTmpfs = true;

        # kernelPackages = pkgs.linuxPackages_zen;
        kernelPackages = pkgs.linuxPackages_xanmod_latest;

        kernelParams = [
          "nowatchdog"
          "skew_tick=1"
          "audit=0"
          "preempt=full"
          "nohz_full=all"
        ];
      };

      environment = {
        systemPackages = with pkgs; [
          lsfg-vk
          lsfg-vk-ui
        ];

        sessionVariables = {
          # Equivalent to Nvidia low-latency mode
          __GL_MaxFramesAllowed = "1";
        };
      };

      programs.gamemode = {
        enable = true;
        enableRenice = true;
        settings = {
          general = {
            renice = 10;
          };

          # custom = {
          # start = "${pkgs.sway}/bin/swaymsg output HDMI-A-1 adaptive_sync on";
          # end = "${pkgs.sway}/bin/swaymsg output HDMI-A-1 adaptive_sync off";
          # };
        };
      };
    }
  ]);
}
