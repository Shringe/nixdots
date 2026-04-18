{ modulesPath, pkgs, ... }:
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ../nixosModules/hardware/kanata
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.nixos = {
    shell = pkgs.nushell;
  };

  nixosModules = {
    hardware = {
      kanata.enable = true;
    };
  };

  environment.etc."nixdots" = {
    source = ./../..;
  };

  environment.systemPackages = with pkgs; [
    smartmontools
    usbutils
    dnslookup
    nushell
    fish
    bash
    neovim
    parted
    networkmanager
    lazygit
    git
    yazi
    disko
    dust
    duf
    ripgrep
    tree
    acpi
    util-linux
    cryptsetup
    btrfs-progs
    coreutils
    age
    ssh-to-age
    sops
    fastfetch
    zellij
    ddrescue
    zoxide
    cmatrix
  ];

  services = {
    # Mouse support in the tty
    gpm.enable = true;
  };
}
