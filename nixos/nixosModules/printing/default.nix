# WIP
# needs driver in nixpkgs
{ pkgs, lib, config, ... }:
let
  cfg = config.nixosModules.printing;
in
{
  imports = [
    # ./cups.nix
  ];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # cups-brother-hl2260d

      # cups-brother-hl2280dw
    ];

    services = {
      printing.enable = true;

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
