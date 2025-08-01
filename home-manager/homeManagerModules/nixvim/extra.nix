{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.nixvim.extra;
in {
  options.homeManagerModules.nixvim.extra = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.nixvim.enable;
      description = "Enable extra tooling for neovim workflow."; 
    };
  };

  # TODO
  # This is mostly just much of my command line tooling now. I should probably refactor.
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Python scripting environment
      (python3.withPackages (ps: with ps; [
        # typer
      ]))
    ];

    programs = {
      fd.enable = true;
      ripgrep.enable = true;
      bat.enable = true;

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      eza = {
        enable = true;
        enableFishIntegration = true;

        icons = "auto";
        git = true;

        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
      };
       
      lazygit.enable = true;
      # neovide.enable = true;

      yazi = {
        enable = true;

        settings = {
          # opener = {
          #   image = [
          #     { run = ''feh "$@"''; orphan = true; }
          #   ];
          # };
          #
          # open = {
          #   rules = [
          #     { mime = "image/*"; use = "image"; }
          #   ];
          # };
        };
      };
    };
  };
}
