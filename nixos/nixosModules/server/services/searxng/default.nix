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
      type = types.str;
      default = "Powerful MetaSearch Engine";
    };

    url = mkOption {
      type = types.str;
      default = "http://${cfg.host}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://searxng.${domain}";
    };

    icon = mkOption {
      type = types.str;
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
          # TODO: actually set up bot protection
          limiter = true;
          link_token = true;
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
          favicon_resolver = "duckduckgo";
        };

        outgoing.request_timeout = 3.0;

        plugins = {
          "searx.plugins.calculator.SXNGPlugin".active = true;
          "searx.plugins.infinite_scroll.SXNGPlugin".active = true;
          "searx.plugins.hash_plugin.SXNGPlugin".active = true;
          "searx.plugins.self_info.SXNGPlugin".active = false;
          "searx.plugins.tracker_url_remover.SXNGPlugin".active = true;
          "searx.plugins.unit_converter.SXNGPlugin".active = true;
          "searx.plugins.ahmia_filter.SXNGPlugin".active = false;
          "searx.plugins.hostnames.SXNGPlugin".active = true;
          "searx.plugins.oa_doi_rewrite.SXNGPlugin".active = true;
          "searx.plugins.tor_check.SXNGPlugin".active = true;
        };

        hostnames = {
          replace = {
            "(.*\.)?nixos\.wiki$" = "wiki.nixos.org";
            "(.*\.)?old\.reddit\.com\$" = "reddit.com";
          };

          high_priority = [
            "(.*\.)?wikipedia.org$"
            "(.*\.)?reddit.com$"
          ];
        };

        engines =
          let
            disableEngine = {
              inactive = true;
              disabled = true;
            };

            disableEngineFix = {
              disabled = true;
            };

            enable =
              attrs:
              {
                inactive = false;
                disabled = false;
              }
              // attrs;

            overrides = {
              # General
              "startpage" = enable { weight = 1.1; };
              "brave" = enable { weight = 1.05; };
              "duckduckgo" = enable { weight = 1.02; };
              "currency" = enable { };
              "wikipedia" = enable { };
              "wikidata" = enable { };
              "ddg definitions" = enable { };

              # Images
              "flickr" = enable { };
              "pexels" = enable { };
              "brave.images" = enable { };
              "startpage images" = enable { };
              "pinterest" = enable { };
              "duckduckgo images" = enable { };
              "deviantart" = enable { };
              "google images" = enable { };
              "bing images" = enable { };
              "wikicommons.images" = enable { };
              "devicons" = enable { };
              "unsplash" = enable { };
              "openverse" = enable { };
              "lucide" = enable { };

              # Videos
              "sepiasearch" = enable { };
              "dailymotion" = enable { };
              "duckduckgo videos" = enable { };
              "youtube" = enable { };
              "brave.videos" = enable { };
              "qwant videos" = enable { };
              "bing videos" = enable { };
              "wikicommons.videos" = enable { };
              "google videos" = enable { };

              # News
              "reuters" = enable { };
              "yahoo news" = enable { };
              "qwant news" = enable { };
              "google news" = enable { };
              "brave.news" = enable { };
              "startpage news" = enable { };
              "duckduckgo news" = enable { };
              "bing news" = enable { };
              "wikinews" = enable { };

              # Map
              "photon" = enable { };
              "openstreetmap" = enable { };

              # Music
              "soundcloud" = enable { };
              "radio browser" = enable { };
              "genius" = enable { };
              "mixcloud" = enable { };
              "bandcamp" = enable { };
              "wikicommons.audio" = enable { };

              # IT
              "gentoo" = enable { };
              "arch linux wiki" = enable { };
              "hoogle" = enable { };
              "docker hub" = enable { };
              "mankier" = enable { };
              "pypi" = enable { };
              "mdn" = enable { };
              "codeberg" = enable { };
              "gitea.com" = enable { };
              "github" = enable { };
              "gitlab" = enable { };
              "huggingface" = enable { };
              "sourcehut" = enable { };
              "caddy.community" = enable { };
              "pi-hole.community" = enable { };
              "askubuntu" = enable { };
              "discuss.python" = enable { };
              "stackoverflow" = enable { weight = 1.01; };
              "superuser" = enable { weight = 1.01; };

              # Science
              "openairedatasets" = enable { };
              "pdbe" = enable { };
              "pubmed" = enable { };
              "google scholar" = enable { };
              "arxiv" = enable { };

              # Files
              "bt4g" = enable { };
              "wikicommons.files" = enable { };
              "piratebay" = enable { };
              "nyaa" = enable { };
              "annas archive" = enable { };

              # Social media
              "tootfinder" = enable { };
              "lemmy posts" = enable { };
              "lemmy comments" = enable { };
              "lemmy users" = enable { };
              "mastodon hashtags" = enable { };
              "lemmy communities" = enable { };
              "mastodon users" = enable { };
              "reddit" = enable { };
            };

            defaults = {
              # General
              ## Books
              "openlibrary" = disableEngine;

              ## Currency
              "currency" = disableEngine;

              ## Translate
              "dictzone" = disableEngine;
              "lingva" = disableEngine;
              "mozhi" = disableEngine;
              "mymemory translated" = disableEngine;

              ## Web
              "bing" = disableEngine;
              "brave" = disableEngineFix;
              "duckduckgo" = disableEngine;
              "google" = disableEngine;
              "mojeek" = disableEngine;
              "presearch" = disableEngineFix;
              "presearch videos" = disableEngine;
              "qwant" = disableEngineFix;
              "startpage" = disableEngine;
              "wiby" = disableEngine;
              "yahoo" = disableEngine;
              "seznam" = disableEngine;
              "naver" = disableEngine;

              ## Wikimedia
              "wikibooks" = disableEngine;
              "wikiquote" = disableEngine;
              "wikisource" = disableEngine;
              "wikispecies" = disableEngine;
              "wikiversity" = disableEngine;
              "wikivoyage" = disableEngine;

              ## Misc
              "ask" = disableEngine;
              "crowdview" = disableEngine;
              "ddg definitions" = disableEngine;
              "encyclosearch" = disableEngine;
              "fynd" = disableEngine;
              "mwmbl" = disableEngine;
              "right dao" = disableEngine;
              "searchmysite" = disableEngine;
              "stract" = disableEngine;
              "tineye" = disableEngine;
              "wikidata" = disableEngine;
              "wikipedia" = disableEngine;
              "wolframalpha" = disableEngine;
              "yacy" = disableEngineFix;
              "yandex" = disableEngineFix;
              "yep" = disableEngine;
              "bpb" = disableEngine;
              "tagesschau" = disableEngine;
              "wikimini" = disableEngine;
              "360search" = disableEngine;
              "baidu" = disableEngine;
              "quark" = disableEngine;
              "sogou" = disableEngine;

              # Images
              ## Icons
              "devicons" = disableEngine;
              "lucide" = disableEngine;
              "material icons" = disableEngine;
              "selfhst icons" = disableEngine;
              "svgrepo" = disableEngine;
              "uxwing" = disableEngine;

              ## Web
              "bing images" = disableEngine;
              "brave.images" = disableEngine;
              "google images" = disableEngine;
              "mojeek images" = disableEngine;
              "presearch images" = disableEngine;
              "qwant images" = disableEngine;
              "startpage images" = disableEngine;

              ## Misc
              "1x" = disableEngine;
              "adobe stock" = disableEngine;
              "artic" = disableEngine;
              "artstation" = disableEngine;
              "deviantart" = disableEngine;
              "duckduckgo images" = disableEngine;
              "findthatmeme" = disableEngine;
              "flickr" = disableEngine;
              "frinkiac" = disableEngine;
              "imgur" = disableEngine;
              "ipernity" = disableEngine;
              "library of congress" = disableEngine;
              "openverse" = disableEngine;
              "pexels" = disableEngine;
              "pinterest" = disableEngine;
              "pixabay images" = disableEngine;
              "public domain image archive" = disableEngine;
              "sogou images" = disableEngine;
              "unsplash" = disableEngine;
              "wikicommons.images" = disableEngine;
              "yacy images" = disableEngine;
              "yandex images" = disableEngine;
              "yep images" = disableEngine;
              "naver images" = disableEngine;
              "baidu images" = disableEngine;
              "quark images" = disableEngine;

              # Videos
              ## Web
              "bing videos" = disableEngine;
              "brave.videos" = disableEngine;
              "google videos" = disableEngine;
              "qwant videos" = disableEngine;

              ## Misc
              "360search videos" = disableEngine;
              "adobe stock video" = disableEngine;
              "bilibili" = disableEngine;
              "bitchute" = disableEngine;
              "dailymotion" = disableEngine;
              "duckduckgo videos" = disableEngine;
              "google play movies" = disableEngine;
              "livespace" = disableEngine;
              "media.ccc.de" = disableEngine;
              "odysee" = disableEngine;
              "peertube" = disableEngine;
              "pixabay videos" = disableEngine;
              "rumble" = disableEngine;
              "sepiasearch" = disableEngine;
              "vimeo" = disableEngine;
              "wikicommons.videos" = disableEngine;
              "youtube" = disableEngine;
              "mediathekviewweb" = disableEngine;
              "ina" = disableEngine;
              "niconico" = disableEngine;
              "naver videos" = disableEngine;
              "acfun" = disableEngine;
              "iqiyi" = disableEngine;
              "sogou videos" = disableEngine;

              # News
              ## Web
              "mojeek news" = disableEngine;
              "presearch news" = disableEngine;
              "startpage news" = disableEngine;

              ## Wikimedia
              "wikinews" = disableEngine;

              ## Misc
              "bing news" = disableEngine;
              "brave.news" = disableEngine;
              "duckduckgo news" = disableEngine;
              "google news" = disableEngine;
              "qwant news" = disableEngine;
              "reuters" = disableEngine;
              "yahoo news" = disableEngine;
              "yep news" = disableEngine;
              "ansa" = disableEngine;
              "il post" = disableEngine;
              "naver news" = disableEngine;
              "sogou wechat" = disableEngine;

              # Map
              "apple maps" = disableEngine;
              "openstreetmap" = disableEngine;
              "photon" = disableEngine;

              # Music
              ## Lyrics
              "genius" = disableEngine;

              ## Radio
              "radio browser" = disableEngine;

              ## Misc
              "adobe stock audio" = disableEngine;
              "bandcamp" = disableEngine;
              "deezer" = disableEngine;
              "mixcloud" = disableEngine;
              "soundcloud" = disableEngine;
              "wikicommons.audio" = disableEngine;
              "yandex music" = disableEngine;

              # IT
              ## Packages
              "alpine linux packages" = disableEngine;
              "cachy os packages" = disableEngine;
              "crates.io" = disableEngine;
              "docker hub" = disableEngine;
              "hex" = disableEngine;
              "hoogle" = disableEngine;
              "lib.rs" = disableEngine;
              "metacpan" = disableEngine;
              "npm" = disableEngine;
              "packagist" = disableEngine;
              "pkg.go.dev" = disableEngine;
              "pub.dev" = disableEngine;
              "pypi" = disableEngine;
              "rubygems" = disableEngine;
              "voidlinux" = disableEngine;

              ## Q&A
              "caddy.community" = disableEngine;
              "pi-hole.community" = disableEngine;
              "askubuntu" = disableEngine;
              "discuss.python" = disableEngine;
              "stackoverflow" = disableEngine;
              "superuser" = disableEngine;

              ## Repos
              "bitbucket" = disableEngine;
              "codeberg" = disableEngine;
              "gitea.com" = disableEngine;
              "github" = disableEngine;
              "gitlab" = disableEngine;
              "huggingface" = disableEngine;
              "sourcehut" = disableEngine;
              "huggingface datasets" = disableEngine;
              "huggingface spaces" = disableEngine;
              "ollama" = disableEngine;

              ## Software wikis
              "arch linux wiki" = disableEngine;
              "free software directory" = disableEngine;
              "gentoo" = disableEngine;
              "nixos wiki" = disableEngine;

              ## Misc
              "anaconda" = disableEngine;
              "habrahabr" = disableEngine;
              "hackernews" = disableEngine;
              "lobste.rs" = disableEngine;
              "mankier" = disableEngine;
              "mdn" = disableEngine;
              "microsoft learn" = disableEngine;
              "national vulnerability database" = disableEngine;
              "baidu kaifa" = disableEngine;

              # Science
              ## Scientific publications
              "arxiv" = disableEngine;
              "crossref" = disableEngine;
              "google scholar" = disableEngine;
              "openalex" = disableEngine;
              "pubmed" = disableEngine;
              "semantic scholar" = disableEngine;

              ## Misc
              "openairedatasets" = disableEngine;
              "openairepublications" = disableEngine;
              "pdbe" = disableEngine;

              # Files
              ## Apps
              "apk mirror" = disableEngine;
              "apple app store" = disableEngine;
              "fdroid" = disableEngine;
              "google play apps" = disableEngine;

              ## Books
              "annas archive" = disableEngine;

              ## Misc
              "1337x" = disableEngine;
              "bt4g" = disableEngine;
              "btdigg" = disableEngine;
              "kickass" = disableEngine;
              "library genesis" = disableEngine;
              "nyaa" = disableEngine;
              "openrepos" = disableEngine;
              "piratebay" = disableEngine;
              "solidtorrents" = disableEngine;
              "tokyotoshokan" = disableEngine;
              "wikicommons.files" = disableEngine;

              # Social media
              "9gag" = disableEngine;
              "lemmy comments" = disableEngine;
              "lemmy communities" = disableEngine;
              "lemmy posts" = disableEngine;
              "lemmy users" = disableEngine;
              "mastodon hashtags" = disableEngine;
              "mastodon users" = disableEngine;
              "reddit" = disableEngine;
              "tootfinder" = disableEngine;

              # Other
              ## Dictionaries
              "etymonline" = disableEngine;
              "wiktionary" = disableEngine;
              "wordnik" = disableEngine;
              "duden" = disableEngine;
              "woxikon.de synonyme" = disableEngine;
              "jisho" = disableEngine;

              ## Movies
              "imdb" = disableEngine;
              "rottentomatoes" = disableEngine;
              "tmdb" = disableEngine;
              "moviepilot" = disableEngine;
              "senscritique" = disableEngine;

              ## Shopping
              "geizhals" = disableEngine;

              ## Software wikis
              "minecraft wiki" = disableEngine;

              ## Weather
              "duckduckgo weather" = disableEngine;
              "openmeteo" = disableEngine;
              "wttr.in" = disableEngine;

              ## Misc
              "emojipedia" = disableEngine;
              "erowid" = disableEngine;
              "fyyd" = disableEngine;
              "goodreads" = disableEngine;
              "podcastindex" = disableEngine;
              "steam" = disableEngine;
              "chefkoch" = disableEngine;
              "destatis" = disableEngine;
            };
          in
          mapAttrsToList (name: value: { inherit name; } // value) (defaults // overrides);
      };
    };
  };
}
