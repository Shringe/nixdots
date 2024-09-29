{ pkgs, ... }:

#let
#  unstable = import <nixos-unstable> {};
#in
{
  environment.systemPackages = with pkgs; [
    alacritty
    rofi
    dunst
    firefox
#    librewolf
#    nordvpn
#    wgnord
  ];

  services.xserver.windowManager.qtile = {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [
      qtile-extras
      # mypy
      #stubtest
    ];
  };
}
