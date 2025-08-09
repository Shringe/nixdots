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
      luaLib = true;
      nvimRuntime = true;
      plugins = true;
    };

    # Currently shows ~12ms decrease with 5 plugins
    # 2025-08-09, I have more plugins now and it is almost a 3x speedup
    combinePlugins = {
      enable = true;
      standalonePlugins = [
        # Builds but don't actually work wihout unpacking
        "friendly-snippets"
        "avante.nvim"

        # All three conflict with eachother ; Two must me unpacked
        "nvim-tree.lua"
        # "blink.cmp"
        "codecompanion.nvim"
      ];
    };
  };
}
