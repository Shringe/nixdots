{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.librewolf;
    policies = {
      Preferences = {
        "middlemouse.paste" = false;

        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;

        "browser.search.defaultenginename" = "SearXNG";
        "browser.search.order.1" = "SearXNG";
      };
 
      ExtensionSettings = {
        "*".installation_mode = "blocked"; # blocks all addons except the ones specified below

        # uBlock Origin:
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
        # Privacy Badger:
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };
      };
    };
  };
  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.librewolf;


    #profiles = {
    #  default = {
    #    id = 0;
    #    name = "default";
    #    isDefault = true;
    #    settings = {     
    #      "middlemouse.paste" = false;

    #      "webgl.disabled" = false;
    #      "privacy.resistFingerprinting" = false;
    #      "privacy.clearOnShutdown.history" = false;
    #      "privacy.clearOnShutdown.cookies" = false;

    #      "browser.search.defaultenginename" = "SearXNG";
    #      "browser.search.order.1" = "SearXNG";
    #    };
    #    #search = {
    #    #  force = true;
    #    #  default = "SearXNG";
    #    #  order = [ "SearXNG" ];
    #    #  engines = {
    #    #    "Nix Packages" = {
    #    #      urls = [{
    #    #        template = "https://search.nixos.org/packages";
    #    #        params = [
    #    #          { name = "type"; value = "packages"; }
    #    #          { name = "query"; value = "{searchTerms}"; }
    #    #        ];
    #    #      }];
    #    #      icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    #    #      definedAliases = [ "@np" ];
    #    #    };
    #    #    "NixOS Wiki" = {
    #    #      urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
    #    #      iconUpdateURL = "https://nixos.wiki/favicon.png";
    #    #      updateInterval = 24 * 60 * 60 * 1000; # every day
    #    #      definedAliases = [ "@nw" ];
    #    #    };
    #    #    "SearXNG" = {
    #    #      urls = [{ template = "https://seek.fyi/?q={searchTerms}"; }];
    #    #      iconUpdateURL = "https://nixos.wiki/favicon.png";
    #    #      updateInterval = 24 * 60 * 60 * 1000; # every day
    #    #      definedAliases = [ "@sx" ];
    #    #    };
    #    #  };
    #    #};
    #    #extensions = with nur.repos.rycee.firefox-addons; [
    #    #  ublock-origin
    #    #  bitwarden
    #    #  vimium
	# # canvas-blocker
	# # privacy-badger
	# # force-copy
    #    #];
    #  };
    #};
  #};
}
