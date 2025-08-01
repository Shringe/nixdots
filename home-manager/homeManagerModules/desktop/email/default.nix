{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.email;

  mbsync = {
    enable = true;
    create = "maildir";
    extraConfig.account.AuthMechs = "PLAIN";
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
    ./meli.nix
  ];

  options.homeManagerModules.desktop.email = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.enable;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        isync = prev.isync.override {
          withCyrusSaslXoauth2 = true;
        };
      })
    ];

    sops.secrets = {
      "email/new" = {};
      "email/old" = {};
      "email/school" = {};
      "email/college/access_token" = {};
    };

    accounts.email = {
      maildirBasePath = "Mail";
      accounts = {
        "new" = {
          address = "dashingkoso@deamicis.top";
          userName = "dashingkoso@deamicis.top";
          realName = "dashingkoso";

          primary = true;
          passwordCommand = "cat ${config.sops.secrets."email/new".path}";

          imap = imapMangoMail;
          smtp = smtpMangoMail;
          notmuch.enable = true;
          mbsync = mbsync;
        };

        "old" = {
          address = "dashingkoso@gmail.com";
          userName = "dashingkoso@gmail.com";
          realName = "dashingkoso";

          passwordCommand = "cat ${config.sops.secrets."email/old".path}";

          flavor = "gmail.com";
          notmuch.enable = true;
          mbsync = mbsync;
        };

        "school" = {
          address = "ldeamicis12@gmail.com";
          userName = "ldeamicis12@gmail.com";
          realName = "Logen";

          passwordCommand = "cat ${config.sops.secrets."email/school".path}";

          flavor = "gmail.com";
          notmuch.enable = true;
          mbsync = mbsync;
        };

        "college" = {
          address = "deamicisl421984@student.nctc.edu";
          userName = "deamicisl421984@student.nctc.edu";
          realName = "Logen";

          passwordCommand = "cat ${config.sops.secrets."email/college/access_token".path}";

          flavor = "outlook.office365.com";
          notmuch.enable = true;
          mbsync = {
            enable = true;
            create = "maildir";
            extraConfig.account.AuthMechs = "XOAUTH2";
            extraConfig.account.SSLType = "IMAPS";
          };
        };
      };
    };

    programs = {
      mbsync.enable = true;
      msmtp.enable = true;

      notmuch = {
        enable = true;
        hooks = {
          preNew = "mbsync --all";
        };
      };
    };

    services = {
      # mbsync.enable = true;
    };
  };
}
