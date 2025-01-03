# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];


  fileSystems."/mnt/Steam/Main" = { 
    device = "/dev/disk/by-uuid/b04355b7-75c9-4c88-9893-536188b2a77a";
    fsType = "btrfs";
    options = [ "subvol=_steam/main" "noatime" ];
    # options = [ "subvol=_steam/main" "noatime" "uid=1000" "gid=989" "umask=755" ];
  };

  fileSystems."/mnt/Steam/libraries/SSD1" = { 
    device = "/dev/disk/by-uuid/b04355b7-75c9-4c88-9893-536188b2a77a";
    fsType = "btrfs";
    options = [ "subvol=_steam/library" "compress=zstd" "noatime" ];
    # options = [ "subvol=_steam/main" "noatime" "uid=1000" "gid=989" "umask=755" ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
