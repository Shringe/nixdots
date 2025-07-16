{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.office.joplin;

  joplinFix = pkgs.writers.writeDashBin "joplinFix" ''
    looking_for="joplin --type=zygote --no-zygote-sandbox"
    get_pid() {
      ${pkgs.procps}/bin/ps axo pid,nice,command | ${pkgs.gnugrep}/bin/grep "$looking_for" | ${pkgs.gawk}/bin/awk '$2 == "-8" {print $1}' | ${pkgs.coreutils}/bin/head -1
    }

    hunt_pid() {
      ${pkgs.coreutils}/bin/sleep 5

      target_pid=$(get_pid)
      if [ -n "$target_pid" ]; then
          ${pkgs.coreutils}/bin/kill "$target_pid"
      else
          echo "No joplin process found with nice value -8"
          exit 1
      fi
    }

    hunt_pid &
    ${pkgs.joplin-desktop}/bin/joplin-desktop "$@"
  '';
in {
  options.homeManagerModules.desktop.office.joplin = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.office.enable;
    };

    enableFix = mkOption {
      type = types.bool;
      default = true;
      description = "On native Wayland joplin-desktop won't open a visible window until a specific child process is killed.";
    };
  };

  config = mkIf cfg.enable {
    programs.joplin-desktop = {
      enable = true;
    };

    home.file.".local/share/applications/joplin.desktop".text = mkIf cfg.enableFix ''
      [Desktop Entry]
      Name=Joplin
      Exec=${joplinFix}/bin/joplinFix --no-sandbox %U
      Terminal=false
      Type=Application
      Icon=joplin
      StartupWMClass=@joplin/app-desktop
      X-AppImage-Version=3.3.13
      MimeType=x-scheme-handler/joplin;
      Comment=Joplin for Desktop
      Categories=Office;
    '';
  };
}
