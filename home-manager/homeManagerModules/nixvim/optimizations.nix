{ pkgs, config, lib, ... }:
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
    combinePlugins = {
      # enable = true; # Currently with on blink-cmp
      standalonePlugins = [
        "nvim-treesitter"
      ];
    };
  };
}
