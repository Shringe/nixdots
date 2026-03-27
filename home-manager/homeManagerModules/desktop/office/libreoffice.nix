{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    lib.mkIf config.homeManagerModules.desktop.office.libreoffice.enable [
      libreoffice
      hunspell
      hunspellDicts.en_US
      hyphenDicts.en_US
    ];
  # programs.libreoffice = lib.mkIf config.homeManagerModules.desktop.office.libreoffice.enable {
  #   enable = true;
  # };
}
