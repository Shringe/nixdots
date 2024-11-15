{ config, lib, ... }:
let
  cfg = config.homeManagerModules.desktop.terminals.alacritty;
in
{
  programs.alacritty = lib.mkIf cfg.enable {
    enable = true;

# [general]
# import = ["~/.config/alacritty/themes/themes/breeze.toml"]
#
# [font.normal]
# # family = "MesloLGS NF"
# family = "JetbrainsMono"
# style = "Regular"
#
# [terminal.shell]
# program = "fish"
#
# [window]
# opacity = 0.88
#
# [window.padding]
# x = 4
# y = 1


  };
}
