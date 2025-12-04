$env.config = {
  edit_mode: "vi"
  show_banner: false
}

def --env nf_wrapper [...raw_args: string] {
  let out = nf --dryrun ...$raw_args

  let split = $out | split row " "
  let command = $split | first
  let args = $split | skip

  match $command {
    "nix" => { nix ...$args }
    "exec" => { exec ...$args }
    _ => {
      print $"Unrecognized command \"($command)\". Exiting."
      exit 1
    }
  }
}

alias nr = nf_wrapper run
alias ns = nf_wrapper shell
alias nd = nf_wrapper develop

alias phone = kdeconnect-cli --device (kdeconnect-cli --list-available | str replace --regex '.*: ([^\s]+) \(.*' "$1")
alias ll = ls -l
alias la = ls -la

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
        let was_empty = $cmd | is-empty
        let cmd = if $was_empty {
          history | last | get command
        } else {
          $cmd
        }

        let has_prefix = $cmd | str starts-with $prefix
        if $was_empty {
          if $has_prefix {
            commandline edit --replace ($cmd | str substring ($prefix | str length)..)
          } else {
            commandline edit --replace ($prefix + $cmd)
          }

          commandline set-cursor --end
        } else {
          let pos = commandline get-cursor
          let len = $prefix | str length

          if $has_prefix {
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
    name: "fzf_env_name"
    modifier: alt
    keycode: char_v
    mode: [emacs vi_normal vi_insert]
    event: {
      send: ExecuteHostCommand
      cmd: "commandline edit --insert ($env | fzf | str replace --all --regex '\\s' '' | str trim --char '│' | split row '│' | get 0)"
    }
  }

  {
    name: "fzf_env_value"
    modifier: control
    keycode: char_v
    mode: [emacs vi_normal vi_insert]
    event: {
      send: ExecuteHostCommand
      cmd: "commandline edit --insert ($env | fzf | str replace --all --regex '\\s' '' | str trim --char '│' | split row '│' | get 1)"
    }
  }
  
  {
    name: "ls"
    modifier: alt
    keycode: char_l
    mode: [emacs vi_normal vi_insert]
    event: {
      send: ExecuteHostCommand
      cmd: "print --no-newline '\n' (ls) '\n'"
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
      cmd: "commandline edit --replace ''"
    }
  }
]
