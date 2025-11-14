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
      util-linux
      systemd
      wait-online
      coreutils
      iproute2
    ];

    text = ''
      rfkill unblock "${cfg.interface}";
      systemctl stop wg-quick-wg0
      systemctl restart iwd
      sleep 3
      ip link set "${cfg.interface}0" down
      ip link set "${cfg.interface}0" up

      if ! wait-online --endpoint "wireguard.${config.nixosModules.reverseProxy.domain}" --delay 200 --max-retries 300; then 
        code="$?"
        systemctl stop iwd
        exit "$code"
      fi

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
