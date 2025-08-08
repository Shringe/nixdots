{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.shells.nushell;
in
{
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
          phone = ''kdeconnect-cli --device (kdeconnect-cli --list-available | str replace --regex '.*: ([^\s]+) \(.*' "$1")'';
          ll = "ls -l";
          la = "ls -la";
        };

        extraConfig = ''
          $env.config.edit_mode = "vi"
          $env.config.show_banner = false

          def --env ncd [dir: path] {
            mkdir $dir
            cd $dir
          }

          $env.config.keybindings ++= [
            {
              name: "prepend_sudo"
              modifier: alt
              keycode: char_s
              mode: [emacs vi_normal vi_insert]
              event: {
                send: ExecuteHostCommand
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
                "
              }
            }
            
            {
              name: "ls"
              modifier: alt
              keycode: char_l
              mode: [emacs vi_normal vi_insert]
              event: {
                send: ExecuteHostCommand
                cmd: "ls"
              }
            }

            {
              name: "clear"
              modifier: control
              keycode: char_l
              mode: [emacs vi_normal vi_insert]
              event: {
                send: ExecuteHostCommand
                cmd: "clear"
              }
            }

            {
              name: "clear_buffer"
              modifier: control
              keycode: char_g
              mode: [emacs vi_insert]
              event: {
                send: ExecuteHostCommand
                cmd: "commandline edit --replace \"\""
              }
            }
          ]
        '';
      };

      zoxide.enableNushellIntegration = true;
      yazi.enableNushellIntegration = true;
      eza.enableNushellIntegration = true;
      atuin.enableNushellIntegration = true;
    };
  };
}
