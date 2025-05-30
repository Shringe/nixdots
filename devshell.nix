{ pkgs, ... }:
pkgs.mkShell {
  buildInputs = with pkgs; [
    fish
    bash
    tmux
    btop
    htop
    acpi

    compose2nix

    git
    vim
    ranger
    kanata

    xorg.xev

    gparted
    parted

    disko
    util-linux
    cryptsetup
    btrfs-progs

    age
    ssh-to-age
    sops
  ];

  shellHook = ''
    echo "Welcome! This devshell is primarily used for debugging and bootstrapping this flake."

    exec fish
  '';
}
