{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    # DisableTelemetry = true;
    profiles.default = {
      policies = {

        DisableTelemetry = true;
      };
    # profiles.default = {};
      settings = {
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.unified" = false;

        "middlemouse.paste" = false;
        "general.autoScroll" = true;

        "webgl.disabled" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.clearOnShutdown.history" = false;
        "privacy.clearOnShutdown.cookies" = false;

        "browser.search.defaultenginename" = "SearXNG";
        "browser.search.order.1" = "SearXNG";
      };
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
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@sx" ];
          };
        };
      };
    };
  };
}

