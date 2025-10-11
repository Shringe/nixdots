{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.searxng;
  domain = config.nixosModules.reverseProxy.domain;
in
{
  options.nixosModules.server.services.searxng = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    port = mkOption {
      type = types.port;
      default = 47480;
    };

    description = mkOption {
      type = types.string;
      default = "Powerful MetaSearch Engine";
    };

    url = mkOption {
      type = types.string;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://searxng.${domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "searxng.svg";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."server/services/searxng" = { };

    services.searx = {
      enable = true;
      redisCreateLocally = true;
      # configureUwsgi = true;
      # configureNginx = true;
      domain = domain;
      settings = {
        server = {
          secret_key = config.sops.secrets."server/services/searxng".path;
          port = cfg.port;
          base_url = cfg.furl;
          bind_address = config.nixosModules.info.system.ips.local;
          limiter = false;
          public_instance = false;
          image_proxy = true;
          method = "GET";
        };

        ui = {
          default_locale = "en";
          query_in_title = true;
          infinite_scroll = true;
          center_alignment = true;
          search_on_category_select = true;
        };

        search = {
          autocomplete = "duckduckgo";
          default_lang = "all";
        };

        enabled_plugins = [
          "Basic Calculator"
          "Hash plugin"
          "Tor check plugin"
          "Open Access DOI rewrite"
          "Hostnames plugin"
          "Unit converter plugin"
          "Tracker URL remover"
        ];

        plugins = {
          "searx.plugins.oa_doi_rewrite.SXNGPlugin".active = true;
        };

        engines = mapAttrsToList (name: value: { inherit name; } // value) {
          # Remove some defaults
          # "startpage".disabled = false;
          "google".disabled = true;

          # Add more
          "startpage".weight = 1.3;
          "qwant".disabled = false;
          "bing".disabled = false;
          "mojeek".disabled = false;
          "mojeek".weight = 0.7;
          # "presearch".disabled = false;
          "wiby".disabled = false;
          "ddg definitions".disabled = false;
          "libretranslate".disabled = false;

          # Misc
          "github code".disabled = false;
          "steam".disabled = false;
          "duckduckgo images".disabled = false;
          "duckduckgo weather".disabled = false;
          "duckduckgo news".disabled = false;
          "duckduckgo videos".disabled = false;
          "minecraft wiki".disabled = false;
          "mojeek images".disabled = false;
          # "presearch images".disabled = false;
          "selfhst icons".disabled = false;

          # Wikipedia
          "wikibooks".disabled = false;
          "wikiquote".disabled = false;
          "wikisource".disabled = false;
          "wikispecies".disabled = false;
          "wikiversity".disabled = false;
          "wikivoyage".disabled = false;
        };
      };
    };
  };
}
