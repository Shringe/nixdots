{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
    dunst
    #    greenclip
    flameshot
    picom
  ];  
}
