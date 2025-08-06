{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.shells.nushell;
in {
  options.homeManagerModules.shells.nushell = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.shells.enable;
    };
  };

  config = mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;
        shellAliases = mkForce {
          nr = "nf run";
          ns = "nf shell";
          nd = "nf develop";
        };

        extraConfig = ''
          $env.config.edit_mode = "vi"
          $env.config.show_banner = false

          $env.config.keybindings = ($env.config.keybindings | append {
            name: "prepend_sudo"
            modifier: alt
            keycode: char_s
            mode: [emacs vi_normal vi_insert]
            event: {
              send: ExecuteHostCommand,
              cmd: "
                let prefix = if (which doas | is-not-empty) {
                  'doas '
                } else {
                  'sudo '
                }

                let cmd = commandline
                if ($cmd | is-empty) {
                  commandline edit --replace ($prefix + (history | last | get command))
                  commandline set-cursor --end
                } else {
                  let pos = commandline get-cursor
                  let len = $prefix | str length

                  if ($cmd | str starts-with $prefix) {
                    commandline edit --replace ($cmd | str substring $len..)
                    commandline set-cursor ($pos - $len)
                  } else {
                    commandline edit --replace ($prefix + $cmd)
                    commandline set-cursor ($pos + $len)
                  }
                }
              ",
            }
          })
        '';
      };

      zoxide.enableNushellIntegration = true;
      yazi.enableNushellIntegration = true;
      eza.enableNushellIntegration = true;
    };
  };
}
