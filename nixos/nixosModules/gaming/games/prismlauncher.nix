{
  pkgs,
  config,
  lib,
  ...
}:
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
          # graalvmPackages.graalvm-oracle
          stable.graalvm-oracle
          # graalvmPackages
          # zulu
        ];
      })
    ];
  };
}
