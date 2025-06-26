{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.email;
in {
  imports = [
    ./neomutt
    ./thunderbird.nix
  ];

  options.homeManagerModules.desktop.email = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    sops.secrets = {
      "email/dashingkoso@deamicis.top" = {};
    };

    accounts.email = {
      maildirBasePath = "Mail";
      accounts = {
        "dashingkoso@deamicis.top" = {
          address = "dashingkoso@deamicis.top";
          userName = "dashingkoso@deamicis.top";
          realName = "dashingkoso";

          primary = true;
          passwordCommand = "cat ${config.sops.secrets."email/dashingkoso@deamicis.top".path}";

          imap = {
            host = "imap.mymangomail.com";
            port = 993;
          };

          smtp = {
            host = "smtp.mymangomail.com";
            port = 465;
          };

          mbsync = {
            enable = true;
            create = "maildir";
          };
        };
      };
    };

    programs = {
      msmtp.enable = true;
      mbsync.enable = true;
    };

    services = {
      mbsync.enable = true;
    };
  };
}
