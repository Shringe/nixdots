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

        shell = {
          anchor_top = true;
          anchor_bottom = true;
          anchor_left = true;
          anchor_right = true;
        };

        columns = {
          symbols = 3;
        };

        placeholders = {
          default = {
            input = "Search";
            list = "No Results";
          };
        };

        keybinds = {
          close = [ "Escape" ];
          next = [ "Down" ];
          previous = [ "Up" ];
          left = [ "Left" ];
          right = [ "Right" ];
          down = [ "Down" ];
          up = [ "Up" ];
          toggle_exact = [ "ctrl e" ];
          resume_last_query = [ "ctrl r" ];
          quick_activate = [
            "F1"
            "F2"
            "F3"
            "F4"
          ];
          page_down = [ "Page_Down" ];
          page_up = [ "Page_Up" ];
          show_actions = [ "alt j" ];
        };

        providers = {
          default = [
            "desktopapplications"
            "calc"
            # "websearch"
          ];
          empty = [ "desktopapplications" ];
          ignore_preview = [ ];
          max_results = 50;

          argument_delimiter = {
            runner = " ";
          };

          prefixes = [
            {
              prefix = ";";
              provider = "providerlist";
            }
            {
              prefix = "/";
              provider = "files";
            }
            {
              prefix = ".";
              provider = "symbols";
            }
            {
              prefix = "=";
              provider = "calc";
            }
            # {
            #   prefix = "@";
            #   provider = "websearch";
            # }
            {
              prefix = ":";
              provider = "clipboard";
            }
            {
              prefix = "$";
              provider = "windows";
            }
          ];

          clipboard = {
            time_format = "%d.%m. - %H:%M";
          };

          actions = {
            fallback = [
              {
                action = "menus:open";
                label = "open";
                after = "Nothing";
              }
              {
                action = "menus:default";
                label = "run";
                after = "Close";
              }
              {
                action = "menus:parent";
                label = "back";
                bind = "Escape";
                after = "Nothing";
              }
              {
                action = "erase_history";
                label = "clear hist";
                bind = "ctrl h";
                after = "AsyncReload";
              }
            ];

            dmenu = [
              {
                action = "select";
                default = true;
                bind = "Return";
              }
            ];

            providerlist = [
              {
                action = "activate";
                default = true;
                bind = "Return";
                after = "ClearReload";
              }
            ];

            bluetooth = [
              {
                action = "find";
                bind = "ctrl f";
                after = "AsyncClearReload";
              }
              {
                action = "remove";
                bind = "ctrl d";
                after = "AsyncReload";
              }
              {
                action = "trust";
                bind = "ctrl t";
                after = "AsyncReload";
              }
              {
                action = "untrust";
                bind = "ctrl t";
                after = "AsyncReload";
              }
              {
                action = "pair";
                bind = "Return";
                after = "AsyncReload";
              }
              {
                action = "connect";
                default = true;
                bind = "Return";
                after = "AsyncReload";
              }
              {
                action = "disconnect";
                default = true;
                bind = "Return";
                after = "AsyncReload";
              }
            ];

            calc = [
              {
                action = "copy";
                default = true;
                bind = "Return";
              }
              {
                action = "delete";
                bind = "ctrl d";
                after = "AsyncReload";
              }
              {
                action = "save";
                bind = "ctrl s";
                after = "AsyncClearReload";
              }
            ];

            websearch = [
              {
                action = "search";
                default = true;
                bind = "Return";
              }
              {
                action = "open_url";
                label = "open url";
                default = true;
                bind = "Return";
              }
            ];

            desktopapplications = [
              {
                action = "start";
                default = true;
                bind = "Return";
              }
              {
                action = "new_instance";
                label = "new instance";
                bind = "ctrl Return";
              }
            ];

            files = [
              {
                action = "open";
                default = true;
                bind = "Return";
              }
              {
                action = "opendir";
                label = "open dir";
                bind = "ctrl Return";
              }
              {
                action = "copypath";
                label = "copy path";
                bind = "ctrl shift c";
              }
              {
                action = "copyfile";
                label = "copy file";
                bind = "ctrl c";
              }
              {
                action = "refresh_index";
                label = "reload";
                bind = "ctrl r";
                after = "AsyncReload";
              }
            ];

            symbols = [
              {
                action = "run_cmd";
                label = "select";
                default = true;
                bind = "Return";
              }
            ];

            unicode = [
              {
                action = "run_cmd";
                label = "select";
                default = true;
                bind = "Return";
              }
            ];

            clipboard = [
              {
                action = "copy";
                default = true;
                bind = "Return";
              }
              {
                action = "remove";
                bind = "ctrl d";
                after = "AsyncClearReload";
              }
              {
                action = "remove_all";
                label = "clear";
                bind = "ctrl shift d";
                after = "AsyncClearReload";
              }
              {
                action = "show_images_only";
                label = "only images";
                bind = "ctrl i";
                after = "AsyncClearReload";
              }
              {
                action = "show_text_only";
                label = "only text";
                bind = "ctrl i";
                after = "AsyncClearReload";
              }
              {
                action = "show_combined";
                label = "show all";
                bind = "ctrl i";
                after = "AsyncClearReload";
              }
              {
                action = "edit";
                bind = "ctrl o";
              }
            ];

            bookmarks = [
              {
                action = "save";
                bind = "Return";
                after = "AsyncClearReload";
              }
              {
                action = "open";
                default = true;
                bind = "Return";
              }
              {
                action = "delete";
                bind = "ctrl d";
                after = "AsyncClearReload";
              }
              {
                action = "change_category";
                label = "Change category";
                bind = "ctrl y";
                after = "Nothing";
              }
              {
                action = "change_browser";
                label = "Change browser";
                bind = "ctrl b";
                after = "Nothing";
              }
              {
                action = "import";
                label = "Import";
                bind = "ctrl i";
                after = "AsyncClearReload";
              }
              {
                action = "create";
                bind = "ctrl a";
                after = "AsyncClearReload";
              }
              {
                action = "search";
                bind = "ctrl a";
                after = "AsyncClearReload";
              }
            ];
          };
        };
      };

      themes = {
        "main" = {
          layouts.layout = ''
            <?xml version="1.0" encoding="UTF-8"?>
            <interface>
              <requires lib="gtk" version="4.0"></requires>
              <object class="GtkWindow" id="Window">
                <style>
                  <class name="window"></class>
                </style>
                <property name="resizable">true</property>
                <property name="title">Walker</property>
                <child>
                  <object class="GtkBox" id="BoxWrapper">
                    <style>
                      <class name="box-wrapper"></class>
                    </style>
                    <property name="overflow">hidden</property>
                    <property name="orientation">horizontal</property>
                    <property name="valign">center</property>
                    <property name="halign">center</property>
                    <property name="width-request">600</property>
                    <property name="height-request">570</property>
                    <child>
                      <object class="GtkBox" id="Box">
                        <style>
                          <class name="box"></class>
                        </style>
                        <property name="orientation">vertical</property>
                        <property name="hexpand-set">true</property>
                        <property name="hexpand">true</property>
                        <property name="spacing">10</property>
                        <child>
                          <object class="GtkBox" id="SearchContainer">
                            <style>
                              <class name="search-container"></class>
                            </style>
                            <property name="overflow">hidden</property>
                            <property name="orientation">horizontal</property>
                            <property name="halign">fill</property>
                            <property name="hexpand-set">true</property>
                            <property name="hexpand">true</property>
                            <child>
                              <object class="GtkEntry" id="Input">
                                <style>
                                  <class name="input"></class>
                                </style>
                                <property name="halign">fill</property>
                                <property name="hexpand-set">true</property>
                                <property name="hexpand">true</property>
                              </object>
                            </child>
                          </object>
                        </child>
                        <child>
                          <object class="GtkBox" id="ContentContainer">
                            <style>
                              <class name="content-container"></class>
                            </style>
                            <property name="orientation">horizontal</property>
                            <property name="spacing">10</property>
                            <child>
                              <object class="GtkLabel" id="ElephantHint">
                                <style>
                                  <class name="elephant-hint"></class>
                                </style>
                                <property name="label">Waiting for elephant...</property>
                                <property name="hexpand">true</property>
                                <property name="vexpand">true</property>
                                <property name="visible">false</property>
                                <property name="valign">0.5</property>
                              </object>
                            </child>
                            <child>
                              <object class="GtkLabel" id="Placeholder">
                                <style>
                                  <class name="placeholder"></class>
                                </style>
                                <property name="label">No Results</property>
                                <property name="hexpand">true</property>
                                <property name="vexpand">true</property>
                                <property name="valign">0.5</property>
                              </object>
                            </child>
                            <child>
                              <object class="GtkScrolledWindow" id="Scroll">
                                <style>
                                  <class name="scroll"></class>
                                </style>
                                <property name="can_focus">false</property>
                                <property name="overlay-scrolling">true</property>
                                <property name="hexpand">true</property>
                                <property name="vexpand">true</property>
                                <property name="max-content-width">500</property>
                                <property name="min-content-width">500</property>
                                <property name="max-content-height">400</property>
                                <property name="min-content-height">400</property>
                                <property name="propagate-natural-height">true</property>
                                <property name="propagate-natural-width">true</property>
                                <property name="hscrollbar-policy">automatic</property>
                                <property name="vscrollbar-policy">automatic</property>
                                <child>
                                  <object class="GtkGridView" id="List">
                                    <style>
                                      <class name="list"></class>
                                    </style>
                                    <property name="max_columns">1</property>
                                    <property name="min_columns">1</property>
                                    <property name="can_focus">false</property>
                                  </object>
                                </child>
                              </object>
                            </child>
                            <child>
                              <object class="GtkBox" id="Preview">
                                <style>
                                  <class name="preview"></class>
                                </style>
                              </object>
                            </child>
                          </object>
                        </child>
                        <child>
                          <object class="GtkBox" id="Keybinds">
                            <property name="hexpand">true</property>
                            <property name="margin-top">10</property>
                            <style>
                              <class name="keybinds"></class>
                            </style>
                            <child>
                              <object class="GtkBox" id="GlobalKeybinds">
                                <property name="spacing">10</property>
                                <style>
                                  <class name="global-keybinds"></class>
                                </style>
                              </object>
                            </child>
                            <child>
                              <object class="GtkBox" id="ItemKeybinds">
                                <property name="hexpand">true</property>
                                <property name="halign">end</property>
                                <property name="spacing">10</property>
                                <style>
                                  <class name="item-keybinds"></class>
                                </style>
                              </object>
                            </child>
                          </object>
                        </child>
                        <child>
                          <object class="GtkLabel" id="Error">
                            <style>
                              <class name="error"></class>
                            </style>
                            <property name="xalign">0</property>
                            <property name="visible">false</property>
                          </object>
                        </child>
                      </object>
                    </child>
                  </object>
                </child>
              </object>
            </interface>
          '';

          style =
            with config.lib.stylix.colors.withHashtag;
            with config.stylix.opacity;
            ''
              @define-color accent     alpha(${base07}, 1);
              @define-color txt        alpha(${base07}, 1);
              @define-color bg         alpha(${base01}, 1);
              @define-color bg2        alpha(${base00}, 1);

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
  };
}
