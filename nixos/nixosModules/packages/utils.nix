{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (writeShellApplication {
      name = "fecho";

      text = ''
        #!/usr/bin/env sh
        echo "> $*"
        "$@"
      '';
    })
  ];
}
