{ lib, ... }:
{
  options.homeManagerModules.info = {
    fps = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 60;
      description = "The fps of your highest refreshrate or primary monitor. Used to set the maximum or target framerate in some applications that don't detect it automatically.";
    };
  };
}
