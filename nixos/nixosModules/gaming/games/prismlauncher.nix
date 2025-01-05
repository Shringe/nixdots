{ pkgs, config, lib, ... }:
let
  cfg = config.nixosModules.gaming.games.prismlauncher;
in
{
  environment.systemPackages = with pkgs; lib.mkIf cfg.enable [
    (prismlauncher.override {
      gamemodeSupport = true;

      jdks = [
        jdk21
        graalvm-ce
        graalvm-oracle
        # graalvmPackages
        zulu
      ];
    })
  ];
}
