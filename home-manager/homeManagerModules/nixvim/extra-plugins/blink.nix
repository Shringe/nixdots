{ config, lib, ... }:
{
  programs.nixvim = {
    plugins.blink-cmp = {
      enable = true;

      settings = {
        sources = {
          per_filetype.codecompanion = lib.mkIf config.programs.nixvim.plugins.codecompanion.enable [
            "codecompanion"
          ];
        };

        completion = {
          ghost_text.enabled = true;
          menu = {
            # Double the default dementions
            min_width = 20;
            max_height = 30;
          };
        };
      };
    };
  };
}
