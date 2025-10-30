{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.nixvim.neovide;
  winblend = 20;
in
{
  options.homeManagerModules.nixvim.neovide = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.nixvim.enable;
      description = "Enable neovide, GUI for neovim gui";
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.neovide.enable = false;
    programs = {
      nixvim = {
        plugins.toggleterm.settings.float_opts = {
          winblend = winblend;
          border = "curved";
        };

        globals = {
          neovide_cursor_vfx_mode = "ripple";
          # neovide_opacity = config.stylix.opacity.terminal;
          neovide_normal_opacity = config.stylix.opacity.terminal;
          neovide_floating_corner_radius = 0.2;
          neovide_floating_shadow = true;
        };

        opts = {
          winblend = winblend;
        };
      };

      neovide = {
        enable = true;

        settings = {
          fork = true;
          # no-multigrid = true;
          font = {
            # Default is fira code
            normal = [ ];
            size = 14;
          };
        };
      };
    };
  };
}
