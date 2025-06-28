{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.email;

  mbsync = {
    enable = true;
    create = "maildir";
  };

  imapMangoMail = {
    host = "imap.mymangomail.com";
    port = 993;
  };

  smtpMangoMail = {
    host = "smtp.mymangomail.com";
    port = 465;
  };
in {
  imports = [
    ./neomutt
    ./aerc
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
      "email/dashingkoso@gmail.com" = {};
      "email/ldeamicis12@gmail.com" = {};
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

          imap = imapMangoMail;
          smtp = smtpMangoMail;
          mbsync = mbsync;
        };

        "dashingkoso@gmail.com" = {
          address = "dashingkoso@gmail.com";
          userName = "dashingkoso@gmail.com";
          realName = "dashingkoso";

          passwordCommand = "cat ${config.sops.secrets."email/dashingkoso@gmail.com".path}";

          flavor = "gmail.com";
          mbsync = mbsync;
        };

        "ldeamicis12@gmail.com" = {
          address = "ldeamicis12@gmail.com";
          userName = "ldeamicis12@gmail.com";
          realName = "Logen";

          passwordCommand = "cat ${config.sops.secrets."email/ldeamicis12@gmail.com".path}";

          flavor = "gmail.com";
          mbsync = mbsync;
        };
      };
    };

    programs = {
      mbsync.enable = true;
      msmtp.enable = true;
    };

    services = {
      mbsync.enable = true;
    };
  };
}
