{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.nixosModules.desktop.windowManagers.sway;
in {
  options.nixosModules.desktop.windowManagers.sway = {
    enable = mkEnableOption "sway setup";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      mako # notification system developed by swaywm maintainer
    ];

    # Enable the gnome-keyring secrets vault. 
    # Will be exposed through DBus to programs willing to store secrets.
    services.gnome.gnome-keyring.enable = true;

    # Needed for sway home manager
    security.polkit.enable = true;

    # enable sway window manager
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };
  };
}
