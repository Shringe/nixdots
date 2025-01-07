{ config, lib, pkgs, ... }:
let
  cfg = config.homeManagerModules.desktop.windowManagers.hyprland.wofi;
in
{
  stylix.targets.wofi.enable = false;

  home.packages = with pkgs; lib.mkIf cfg.enable [
    wofi-emoji
  ];

  programs.wofi = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      allow_images = true;
      hide_scroll=true;
      normal_window=true;
      insensitive=true;
      width = 800;
      height = 650;
      no_actions=true;
    };

    style = ''
      @define-color accent #${config.lib.stylix.colors.base07};
      @define-color txt #${config.lib.stylix.colors.base07};
      @define-color bg #${config.lib.stylix.colors.base01};
      @define-color bg2 #${config.lib.stylix.colors.base00};

      * {
          font-family: 'CaskaydiaCove Nerd Font mono';
          font-size: 14px;
       }

       /* Window */
       window {
          margin: 0px;
          padding: 4px;
          # border-radius: 16px;
          background-color: @bg;
       }

       /* Inner Box */
       #inner-box {
          margin: 5px;
          padding: 10px;
          border: none;
          border-radius: 5px;
          background-color: @bg;
       }

       /* Outer Box */
       #outer-box {
          margin: 5px;
          padding: 10px;
          border: none;
          background-color: @bg;
          border-radius: 5px;
       }

       /* Scroll */
       #scroll {
          margin: 0px;
          padding: 10px;
          border: none;
       }

       /* Input */
       #input {
          margin: 5px;
          padding: 10px;
          border: none;
          color: @accent;
          background-color: @bg;
          border: 2px solid @accent;
       }

       /* Text */
       #text {
          margin: 5px;
          padding: 10px;
          border: none;
          color: @txt;
       }

       /* Selected Entry */
       #entry:selected {
         background-color: @bg;
         outline: 1px solid @accent;
       }

       #entry:selected #text {
          color: @txt;
       }
       image {
         margin-left: 10px;
       }
    '';
  };
}
