{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.nixvim.git;
in
{
  options.homeManagerModules.nixvim.git = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.nixvim.enable;
      # default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "Shringe";
          email = "git@nsaria.com";
        };

        credential.helper = "store";
        safe.directory = [
          "/nixdots"
          "/nixdots/.git"
        ];
      };
    };
  };
}
