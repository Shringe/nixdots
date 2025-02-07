{ pkgs, config, lib, inputs, ... }:
let
  cfg = config.nixosModules.gaming.games.roblox;
in
{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  services.flatpak = lib.mkIf cfg.enable {
    enable = true;
    packages = [
      { flatpakref = "https://sober.vinegarhq.org/sober.flatpakref"; sha256="1pj8y1xhiwgbnhrr3yr3ybpfis9slrl73i0b1lc9q89vhip6ym2l"; }
    ];
  };
}
