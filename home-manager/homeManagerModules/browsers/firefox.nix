{ config, lib, pkgs, inputs, ... }:
  let
    lock-false = {
      Value = false;
      Status = "locked";
    };
    lock-true = {
      Value = true;
      Status = "locked";
    };
  in
{
  config = {
    programs.firefox = lib.mkIf config.homeManagerModules.browsers.firefox.enable {
      enable = true;
      languagePacks = [ "en-US" ];
      profiles.default.extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        vimium
        canvasblocker
        privacy-badger
        bitwarden
      ];

      /* ---- POLICIES ---- */
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = false;
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

        /* ---- EXTENSIONS ---- */
        # Extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        #
        #   bitwarden
        #   ublock-origin
        #   youtube-shorts-block
        # ];
        #
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        # ExtensionSettings = {
        #   "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
        #   # uBlock Origin:
        #   "uBlock0@raymondhill.net" = {
        #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        #     installation_mode = "force_installed";
        #   };
        #   # Privacy Badger:
        #   "jid1-MnnxcxisBPnSXQ@jetpack" = {
        #     install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
        #     installation_mode = "force_installed";
        #   };
        #   # Bitwarden
        #   "Bitwarden" = {
        #     install_url = "https://addons.mozilla.org/firefox/downloads/file/4363548/bitwarden_password_manager-2024.10.0.xpi";
        #     installation_mode = "force_installed";
        #   };
        #
        #   # 1Password:
        #   # "{d634138d-c276-4fc8-924b-40a0ea21d284}" = {
        #   #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/1password-x-password-manager/latest.xpi";
        #   #   installation_mode = "force_installed";
        #   # };
        # };


        search = {
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "SearXNG" = {
              urls = [{
                template = "https://seek.fyi/search?q={searchTerms}";
                params = [
                  { name = "type"; value = "engines"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              # icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@sx" ];
            };
          };
        };
        /* ---- PREFERENCES ---- */
        # Check about:config for options.
        Preferences = { 
          "full-screen-api.transition-duration.enter" = [ 0 0 ];
          "full-screen-api.transition-duration.leave" = [ 0 0 ];
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
        };
      };
    };
  };
}
