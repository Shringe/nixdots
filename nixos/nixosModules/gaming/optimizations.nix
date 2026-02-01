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
      # TODO: try enabling in the future
      services.pipewire.lowLatency = {
        enable = true;
        quantum = 512;
        alsa.enable = true;
      };

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

        kernelModules = [
          "ntsync"
        ];
      };

      environment = {
        systemPackages = with pkgs; [
          lsfg-vk
          lsfg-vk-ui
          (pkgs.writers.writeDashBin "zink-run" ''
            exec env __GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json MESA_LOADER_DRIVER_OVERRIDE=zink GALLIUM_DRIVER=zink "$@"
          '')
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

          custom = {
            # start = "${pkgs.sway}/bin/swaymsg output HDMI-A-1 adaptive_sync on";
            # end = "${pkgs.sway}/bin/swaymsg output HDMI-A-1 adaptive_sync off";

            start = "$HOME/.local/bin/gamemode_start.sh";
            end = "$HOME/.local/bin/gamemode_end.sh";
          };
        };
      };
    }
  ]);
}
