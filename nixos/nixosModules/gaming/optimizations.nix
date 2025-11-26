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

  config = mkIf cfg.enable {
    nix.settings = {
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      lowLatency = {
        enable = true;
      };
    };

    # make pipewire realtime-capable
    security.rtkit.enable = true;

    # SteamOS platform optimizations
    programs.steam.platformOptimizations.enable = true;

    boot.kernel.sysctl = {
      "vm.swappiness" = 20;
    };

    boot = {
      tmp.useTmpfs = true;

      # kernelPackages = pkgs.linuxKernel.kernels.linux_zen;
      kernelPackages = pkgs.linuxPackages_zen;
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

        custom = {
          start = "${pkgs.sway}/bin/swaymsg output HDMI-A-1 adaptive_sync on";
          end = "${pkgs.sway}/bin/swaymsg output HDMI-A-1 adaptive_sync off";
        };
      };
    };
  };
}
