{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.nixosModules.gaming.games.prismlauncher;
in
{
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (prismlauncher.override {
        gamemodeSupport = true;

        jdks = [
          jdk21
          jdk17
          graalvm-ce
          # graalvm-oracle
          # graalvmPackages
          zulu
        ];
      })
    ];
  };
}
