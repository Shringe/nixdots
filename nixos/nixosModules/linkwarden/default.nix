{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.nixosModules.linkwarden;
in
{
  imports = [
    # ./module.nix
  ];

  options.nixosModules.linkwarden = {
    enable = mkEnableOption "linkwarden";

    port = mkOption {
      type = types.port;
      default = 41040;
    };

    description = mkOption {
      type = types.str;
      default = "Fancy Bookmark Manager";
    };

    url = mkOption {
      type = types.str;
      default = "http://${config.nixosModules.info.system.ips.local}:${toString cfg.port}";
    };

    furl = mkOption {
      type = types.str;
      default = "https://linkwarden.${config.nixosModules.reverseProxy.domain}";
    };

    icon = mkOption {
      type = types.str;
      default = "linkwarden.png";
    };

    directory = mkOption {
      type = types.str;
      # default = "/mnt/server/critical/linkwarden";
      default = "/var/lib/linkwarden";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "linkwarden" = {
        owner = "linkwarden";
      };
    };

    services.linkwarden = {
      enable = true;
      # package = (pkgs.callPackage ../../../shared/packages/linkwarden.nix { });
      host = config.nixosModules.info.system.ips.local;
      port = cfg.port;
      environmentFile = config.sops.secrets."linkwarden".path;
      storageLocation = cfg.directory;
      enableRegistration = true;

      environment = {
        NEXT_PUBLIC_OLLAMA_ENDPOINT_URL = config.nixosModules.server.services.ollama.furl;
        OLLAMA_MODEL = "phi3:mini-4k";
        # OLLAMA_MODEL = "granite4:3b";
        # OLLAMA_MODEL = "qwen3:8b";
        # OLLAMA_MODEL = "qwen3:4b";
        BASE_URL = cfg.furl;
      };
    };
  };
}
