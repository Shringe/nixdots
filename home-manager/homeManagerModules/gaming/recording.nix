# TODO: Add recording alongside replay options to menu
# TODO: Dynamically determine and record only the game window (maybe hook into hyprland fullscreen hotkey?)
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.gaming.recording;

  clip-manager = pkgs.writers.writeNu "clip-manager" ''
    # Takes in an array of menu entries to prompt the user with
    def prompt_menu [] {
      $in | str join "\n" | ${pkgs.walker}/bin/walker --dmenu
    }

    def notify [icon: string, msg: string] {
      ${pkgs.swayosd}/bin/swayosd-client --custom-icon=$"($icon)" --custom-message=$"($msg)"
    }

    def "main menu" [] {
      let options = [
        [
          entry
          notify
          value
        ];
        [
          "Save Last 30 Seconds"
          "Saved 30 Second Clip"
          "SIGRTMIN+2"
        ]
        [
          "Save Last 60 Seconds"
          "Saved 60 Second Clip"
          "SIGRTMIN+3"
        ]
        [
          "Save Last 5 Minutes"
          "Saved 5 Minute Clip"
          "SIGRTMIN+4"
        ]
      ]

      let choice = $options | get entry | prompt_menu
      let action = $options | where entry == $choice | first

      pkill $"-($action.value)" -f "${pkgs.gpu-screen-recorder}/bin/.wrapped/gpu-screen-recorder"
      notify "media-record" $"($action.notify)"
    }

    def "main start" [] {
      notify "media-record" "Background Recording Started"

      exec ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w ${cfg.monitor} -c mkv -o $"($env.HOME)/Videos/Replay/clips" -ro $"($env.HOME)/Videos/Replay/recordings" -a "default_output" -r 300 -k hevc_10bit -cr full -bm cbr -q 25000
      # exec ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w ${cfg.monitor} -c mkv -o $"($env.HOME)/Videos/Replay/clips" -ro $"($env.HOME)/Videos/Replay/recordings" -a "default_output" -r 300
      # exec ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder -w ${cfg.monitor} -c mkv -o $"($env.HOME)/Videos/Replay/clips" -ro $"($env.HOME)/Videos/Replay/recordings" -a "default_output|default_input" -r 300
    }

    def "main end" [] {
      notify "media-record" "Background Recording Stopped"
    }

    def main [] {
      print "./recorder.nu --help for more information"
      exit 1
    }
  '';
in
{
  options.homeManagerModules.gaming.recording = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable background recording of games in order to allow saving clips";
    };

    monitor = mkOption {
      type = types.str;
      default = "HDMI-A-1";
      description = "Monitor to record";
    };
  };

  config = mkIf cfg.enable {
    systemd.user.tmpfiles.rules = [
      "d %h/Videos 0755"
      "d %h/Videos/Replay 0755"
      "d %h/Videos/Replay/clips 0755"
      "d %h/Videos/Replay/recordings 0755"
    ];

    systemd.user.services.clip-manager = {
      Unit = {
        Description = "Background recording of games for clips";
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        ExecStart = "${clip-manager} start";
        ExecStop = "${clip-manager} end";
        Restart = "on-failure";
      };
    };

    home.file = {
      ".local/bin/clip-manager".source = clip-manager;

      # Gamemode hooks
      ".local/bin/gamemode_start.sh".source =
        pkgs.writers.writeDash "gamemode_start" "${pkgs.systemd}/bin/systemctl --user start clip-manager --no-block";
      ".local/bin/gamemode_end.sh".source =
        pkgs.writers.writeDash "gamemode_end" "${pkgs.systemd}/bin/systemctl --user stop clip-manager --no-block";
    };
  };
}
