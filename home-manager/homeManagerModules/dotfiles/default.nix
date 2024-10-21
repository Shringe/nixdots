{ lib, config, ... }:
{
  imports = [
    ./dots
  ];

  options = {
    dotfiles = {
    };
  };
  # config.dotfiles.qtile.installDependencies = true;
}
