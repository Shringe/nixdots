{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixosModules.theming.wallpapers;

  setupProtected = pkgs.writeShellApplication {
    name = "setupProtected";
    runtimeInputs = with pkgs; [
      rclone
    ];

    text = ''
      rclone copy \
        --webdav-url "$SHARE_URL" \
        --webdav-user "$SHARE_TOKEN" \
        --webdav-pass "$(rclone obscure "$SHARE_PASS")" \
        :webdav: \
        .
    '';
  };
in
{
  options.nixosModules.theming.wallpapers = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.nixosModules.theming.enable;
      description = "Whether to setup wallpapers in /usr/local/share/wallpapers";
    };

    protected = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      description = "Download password protected wallpapers from nextcloud";
    };

    directories = {
      base = lib.mkOption {
        type = lib.types.externalPath;
        default = "/usr/local/share/wallpapers";
      };

      protected = lib.mkOption {
        type = lib.types.externalPath;
        default = "${cfg.directories.base}/protected";
      };

      public = lib.mkOption {
        type = lib.types.externalPath;
        default = "${cfg.directories.base}/public";
      };

      publicSource = lib.mkOption {
        type = lib.types.path;
        default = ./../../../assets/wallpapers;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    sops.secrets."theming/wallpapers/share" = { };

    systemd.tmpfiles.rules = [
      "d  ${cfg.directories.protected} 0750 ${config.users.users.wallman.name} ${config.users.groups.wallie.name} -"
      # "L+ ${cfg.directories.public}    0750 ${config.users.users.wallman.name} ${config.users.groups.wallie.name} ${cfg.directories.publicSource}"
    ];

    # For wallpaper management
    users.users.wallman = {
      isSystemUser = true;
      group = config.users.groups.wallman.name;
    };

    users.groups.wallman = { };

    # For wallpaper access
    users.groups.wallie = { };

    system.activationScripts.public-wallpapers-sync = {
      text = ''
        ln -sfn "${cfg.directories.publicSource}" "${cfg.directories.public}"
      '';
    };

    systemd.services.protected-wallpaper-sync = lib.mkIf cfg.protected {
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = cfg.directories.protected;
        User = config.users.users.wallman.name;
        EnvironmentFile = config.sops.secrets."theming/wallpapers/share".path;
        ExecStart = "${setupProtected}/bin/setupProtected";
      };
    };

    systemd.timers.protected-wallpaper-sync = lib.mkIf cfg.protected {
      wantedBy = [ "timers.target" ];

      timerConfig = {
        OnCalendar = "weekly";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
    };
  };
}
