{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.networking.wireless;
  fixWlanHook = pkgs.writers.writeDash "fixWlanHook" ''
    case $1 in
      post) ${pkgs.systemd}/bin/systemctl restart fixWlan --no-block
    esac
  '';

  fixWlan = pkgs.writeShellApplication {
    name = "fixWlan";

    runtimeInputs = with pkgs; [
      iproute2
      util-linux
      coreutils
    ];

    text = ''
      rfkill unblock ${cfg.interface}
      systemctl stop wg-quick-wg0
      systemctl start iwd
      sleep 1
      ip link set wlan0 down
      sleep 1
      ip link set wlan0 up
      sleep 15
      systemctl start wg-quick-wg0
    '';
  };
in
{
  imports = [
    ./wpa.nix
    ./iwd.nix
    ./networkmanager.nix
  ];

  options.nixosModules.networking.wireless = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    unblockInterface = mkOption {
      type = types.bool;
      default = cfg.enable;
    };

    interface = mkOption {
      type = types.str;
      default = "wlan";
      description = "Name of interface to use for cfg.unblockInterface";
    };
  };

  config = mkIf cfg.unblockInterface {
    systemd.services.fixWlan = {
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${fixWlan}/bin/fixWlan";
      };

      # wantedBy = [ "multi-user.target" ];
      # requisite = [ "iwd.service" ];
      # after = [ "iwd.service" ];
    };

    systemd.services.iwd = {
      wantedBy = mkForce [ ];
    };

    environment.etc."systemd/system-sleep/fixWlan" = {
      source = fixWlanHook;
      # mode = "0755";
    };
  };
}
