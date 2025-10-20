{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  lock-false = {
    Value = false;
    Status = "locked";
  };

  lock-true = {
    Value = true;
    Status = "locked";
  };

  cfg = config.homeManagerModules.desktop.browsers.firefox;

  mkSxngSearch = url: abbr: {
    urls = [
      {
        template = "https://${url}/search?q={searchTerms}";
        params = [
          {
            name = "type";
            value = "engines";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [ abbr ];
  };

  mkNixosSearch = type: abbr: {
    urls = [
      {
        template = "https://search.nixos.org/${type}";
        params = [
          {
            name = "type";
            value = "packages";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ abbr ];
  };

  mkSearchixSearch = type: abbr: {
    urls = [
      {
        template = "https://searchix.ovh/${type}/search";
        params = [
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];

    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ abbr ];
  };
in
{
  options.homeManagerModules.desktop.browsers.firefox = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.browsers.enable;
    };

    search = mkOption {
      type = types.attrs;
      default = {
        force = true;
        default = "SearXNG";
        order = [
          "SearXNG"
          "SearBe"
          "SearFYI"
        ];

        engines = cfg.engines;
      };
    };

    engines = mkOption {
      type = types.attrs;
      default = {
        "Nix Packages" = mkNixosSearch "packages" "@np";
        "Nix Options" = mkNixosSearch "options" "@no";

        "Nix HomeManager Options" = mkSearchixSearch "options/home-manager" "@nh";
        "Nix User Repository" = mkSearchixSearch "packages/nur" "@nu";

        "SearBe" = mkSxngSearch "searx.be" "@sxb";
        "SeekFYI" = mkSxngSearch "seek.fyi" "@sxf";
        "SearXNG" = mkSxngSearch "searxng.deamicis.top" "@sx";
      };
    };

    profiles = mkOption {
      type = types.attrs;
      default = {
        default = {
          extensions = {
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              vimium
              canvasblocker
              privacy-badger
              return-youtube-dislikes
              bitwarden
              new-tab-override
              darkreader
              youtube-shorts-block
              linkwarden
              languagetool
            ];
          };

          search = cfg.search;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    stylix.targets.firefox.profileNames = [ "default" ];

    programs.firefox = {
      enable = true;
      languagePacks = [ "en-US" ];
      profiles = cfg.profiles;

      # ---- POLICIES ----
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"

        # ---- PREFERENCES ----
        # Check about:config for options.
        Preferences = {
          "full-screen-api.transition-duration.enter" = [
            0
            0
          ];
          "full-screen-api.transition-duration.leave" = [
            0
            0
          ];
          "full-screen-api.delay" = "-1";
          "full-screen-api.timeout" = "-1";
          "extensions.pocket.enabled" = lock-false;
          "extensions.screenshots.disabled" = lock-true;
          "browser.topsites.contile.enabled" = lock-false;
          "browser.formfill.enable" = lock-false;
          # "browser.search.suggest.enabled" = lock-false;
          # "browser.search.suggest.enabled.private" = lock-false;
          # "browser.urlbar.suggest.searches" = lock-false;
          # "browser.urlbar.showSearchSuggestionsFirst" = lock-false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = lock-false;
          "browser.newtabpage.activity-stream.feeds.snippets" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = lock-false;
          "browser.newtabpage.activity-stream.section.highlights.includeVisited" = lock-false;
          "browser.newtabpage.activity-stream.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.system.showSponsored" = lock-false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = lock-false;

          "browser.startup.homepage" = "https://dash.deamicis.top";
        };
      };
    };
  };
}
