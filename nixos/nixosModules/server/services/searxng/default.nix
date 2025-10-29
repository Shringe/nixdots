{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.nixosModules.server.services.searxng;
  domain = config.nixosModules.reverseProxy.domain;

  # Abstracted because google often breaks and I must switch to another google proxy
  googleWeight = 1.15;
in
{
  imports = [
    ./vpn.nix
  ];

  options.nixosModules.server.services.searxng = {
    enable = mkOption {
      type = types.bool;
      default = config.nixosModules.server.services.enable;
    };

    host = mkOption {
      type = types.str;
      default = config.nixosModules.info.system.ips.local;
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
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.string;
      default = "https://searxng.${domain}";
    };

    icon = mkOption {
      type = types.string;
      default = "searxng.svg";
    };

    useVpn = mkOption {
      type = types.bool;
      default = false;
      description = "Pipe outgoing requests through a dedicated vpn tunnel";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."server/services/searxng/key" = { };

    services.searx = {
      enable = true;
      redisCreateLocally = true;
      # configureUwsgi = true;
      # configureNginx = true;
      domain = domain;
      settings = {
        server = {
          secret_key = config.sops.secrets."server/services/searxng/key".path;
          port = cfg.port;
          base_url = cfg.furl;
          bind_address = cfg.host;
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
          search_on_category_select = false;
        };

        search = {
          autocomplete = "duckduckgo";
          default_lang = "en";
        };

        outgoing.request_timeout = 5.0;

        enabled_plugins = [
          "Basic Calculator"
          "Hash plugin"
          "Tor check plugin"
          "Open Access DOI rewrite"
          "Hostnames plugin"
          "Unit converter plugin"
          "Tracker URL remover"
        ];

        hostnames = {
          replace = {
            "(.*\.)?nixos\.wiki$" = "wiki.nixos.org";
          };

          high_priority = [
            "(.*\.)?wikipedia.org$"
            "(.*\.)?reddit.com$"
          ];
        };

        engines = mapAttrsToList (name: value: { inherit name; } // value) {
          "startpage" = {
            disabled = true;
            weight = googleWeight;
          };

          "google" = {
            disabled = true;
            weight = googleWeight;
          };

          "mullvadleta" = {
            disabled = false;
            weight = googleWeight;
          };

          "mojeek" = {
            disabled = false;
            weight = 0.7;
          };

          "brave" = {
            disabled = false;
            weight = 1.05;
          };

          # Add more
          "qwant".disabled = false;
          "bing".disabled = true;
          "presearch".disabled = false;
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
          "presearch images".disabled = false;
          "selfhst icons".disabled = false;
          "wallhaven".disabled = false;
          "imgur".disabled = false;
          "material icons".disabled = false;
          "svgrepo".disabled = false;
          "google news".disabled = true;
          "yahoo news".disabled = true;
          "lib.rs".disabled = false;
          "crates.io".disabled = false;
          "codeberg".disabled = false;
          "gitea.com".disabled = false;
          "gitlab".disabled = false;
          "sourcehut".disabled = false;
          "nixos wiki".disabled = false;
          "free software directory".disabled = false;
          "hackernews".disabled = false;
          "lobste.rs".disabled = false;
          "crossref".disabled = false;
          "semantic scholar".disabled = false;
          "fdroid".disabled = false;
          "apk mirror".disabled = false;
          "nyaa".disabled = false;
          "openrepos".disabled = false;
          "annas archive".disabled = false;
          "1337x".disabled = false;
          "reddit".disabled = false;
          "9gag".disabled = false;
          "emojipedia".disabled = false;

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
