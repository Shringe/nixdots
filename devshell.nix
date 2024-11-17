{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    fish
    bash

    git
    vim
    kanata

    disko
    util-linux
    cryptsetup

    age
    sops
  ];

  shellHook = ''
    echo "Welcome! This devshell is primarily used for debugging and bootstrapping this flake."

    exec fish
  '';
}
