{ config, lib, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.email.neomutt;
in {
  options.homeManagerModules.desktop.email.neomutt = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.email.enable;
    };
  };

  config = mkIf cfg.enable {
    accounts.email = {
      maildirBasePath = "Mail";
      accounts = {
        "dashingkoso" = {
          address = "dashingkoso@deamicis.top";
          userName = "dashingkoso@deamicis.top";
          realName = "dashingkoso";

          primary = true;
          passwordCommand = "cat ~/pass";

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

          neomutt.enable = true;
        };
      };
    };


    programs = {
      neomutt = {
        enable = true;
        vimKeys = true;
      };

      msmtp.enable = true;
      mbsync.enable = true;
    };

    services = {
      mbsync.enable = true;
    };
  };
}
