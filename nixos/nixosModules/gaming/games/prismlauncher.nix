{ unstablePkgs, config, lib, ... }:
let
  cfg = config.nixosModules.gaming.games.prismlauncher;
in
{
  environment.systemPackages = lib.mkIf cfg.enable [
    (unstablePkgs.prismlauncher.override {
      gamemodeSupport = true;

      jdks = with unstablePkgs; [
        jdk21
        jdk17
        graalvm-ce
        # graalvm-oracle
        # graalvmPackages
        zulu
      ];
    })
  ];
}
