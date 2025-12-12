{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.desktop.windowManagers.utils.walker;
in
{
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  options.homeManagerModules.desktop.windowManagers.utils.walker = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.walker = {
      enable = true;
      runAsService = true;

      config = {
        theme = "main";
      };

      themes."main" = {
        style =
          with config.lib.stylix.colors.withHashtag;
          with config.stylix.opacity;
          ''
            @define-color accent     alpha(${base07}, ${toString desktop});
            @define-color txt        alpha(${base07}, ${toString desktop});
            @define-color bg         alpha(${base01}, ${toString desktop});
            @define-color bg2        alpha(${base00}, ${toString desktop});

            * {
              # all: unset;
              font-family: "JetBrains";
              font-size: 16px;
              border-radius: 8px;
            }

            /* Main window wrapper */
            .box-wrapper {
              background: @bg;
              padding: 4px;
              border-radius: 8px;
              border: 2px solid @accent;
            }

            /* Search input */
            .input {
              caret-color: @txt;
              background: @bg2;
              padding: 10px;
              margin: 5px;
              color: @accent;
              border: 1px solid @accent;
              border-radius: 8px;
            }

            .input placeholder {
              opacity: 0.5;
              color: @accent;
            }

            .input selection {
              background: lighter(@bg);
            }

            /* Results list container */
            .list {
              color: @txt;
              padding: 10px;
              margin: 5px;
            }

            /* Individual items */
            .item-box {
              border-radius: 5px;
              padding: 10px;
              margin: 5px;
            }

            /* Selected item */
            child:selected .item-box {
              background: @bg;
              outline: 1px solid @accent;
            }

            /* Item text */
            .item-text {
              color: @txt;
            }

            child:selected .item-text {
              color: @txt;
            }

            /* Item icons */
            .item-image {
              margin-left: 10px;
            }

            /* Scrollbar */
            scrollbar {
              opacity: 0;
            }

            /* Content container */
            .content-container {
              margin: 5px;
              padding: 10px;
              border: none;
            }
          '';
      };
    };
  };
}
