{ lib, ... }:
with lib;
{
  imports = [
    ./greetd
    ./ly.nix
    ./lightdm.nix
  ];

  config = {
    services = {
      displayManager = {
        defaultSession = mkForce "sway";
        hiddenUsers = [ "arm" "qbittorent" "filebrowser" ];
      };

      # xserver.displayManager = {
      #   setupCommands = ''
      #     xrandr --output HDMI-0 --refresh 175 --mode 3440x1440 --primary
      #   '';
      # };
    };
  };
}
