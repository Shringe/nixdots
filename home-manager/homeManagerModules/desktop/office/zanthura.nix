{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeManagerModules.desktop.office.pdf;

  # "Copies selection clipboard to system clipboard";
  copy = pkgs.writeShellApplication {
    name = "copy";

    runtimeInputs = with pkgs; [
      wl-clipboard
    ];

    text = ''
      wl-paste --primary | wl-copy
    '';
  };
in
{
  programs.zathura = lib.mkIf cfg.enable {
    enable = true;

    mappings = {
      "<C-c>" = "exec ${copy}/bin/copy";
    };
  };
}
