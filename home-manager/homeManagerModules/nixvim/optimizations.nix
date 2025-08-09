{
  pkgs,
  config,
  lib,
  ...
}:
{
  home.packages = [ pkgs.vim-startuptime ];

  # Tested with:
  # time vim-startuptime -vimpath nvim
  programs.nixvim.performance = lib.mkIf config.homeManagerModules.nixvim.optimizations {
    # ~25% speed up
    byteCompileLua = {
      enable = true;
      configs = true;
      initLua = true;
      nvimRuntime = true;
      plugins = true;
    };

    # Currently shows ~12ms decrease with 5 plugins
    # 2025-08-09, I have more plugins now and it is almost a 3x speedup
    combinePlugins = {
      enable = true;
      standalonePlugins = [
        "nvim-treesitter"
        "blink.cmp"
        "codecompanion.nvim"
      ];
    };
  };
}
