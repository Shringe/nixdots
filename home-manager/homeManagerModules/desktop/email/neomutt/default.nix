{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homeManagerModules.desktop.email.neomutt;

  syncIntervalSeconds = 30;

  mailSync = pkgs.writeShellApplication {
    name = "mailSync";
    runtimeInputs = with pkgs; [
      isync
      coreutils
    ];

    text = ''
      mbsync new &
      mbsync old &
      mbsync school &
      mbsync college &
      wait
    '';
  };
in {
  options.homeManagerModules.desktop.email.neomutt = {
    enable = mkOption {
      type = types.bool;
      default = config.homeManagerModules.desktop.email.enable;
    };

    theme = mkOption {
      type = types.str;
      default = "catppuccin";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      mailSync
    ];

    accounts.email.accounts = {
      "new".neomutt.enable = true;
      "old".neomutt.enable = true;
      "school".neomutt.enable = true;
      "college".neomutt.enable = true;
    };

    systemd.user = {
      services.mailSync = {
        Unit = {
          Description = "Mailbox synchronization";
          After = [ "network-online.target" ];
        };

        Service = {
          Type = "oneshot";
          ExecStart = "${mailSync}/bin/mailSync";
        };
      };

      timers.mailSync = {
        Unit = {
          Description = "Run mbsync every ${toString syncIntervalSeconds} seconds";
          Requires = [ "mailSync.service" ];
        };

        Timer = {
          OnCalendar = "*:*:0/${toString syncIntervalSeconds}";
          Persistent = true;
        };
      };
    };

    xdg.configFile."mailcap".text = ''
      # Text formats
      text/html; ${pkgs.lynx}/bin/lynx -dump %s; nametemplate=%s.html; copiousoutput
      text/plain; ${pkgs.less}/bin/less %s; needsterminal

      # Documents
      application/pdf; ${pkgs.zathura}/bin/zathura %s
      application/pdf; ${pkgs.poppler_utils}/bin/pdftotext %s -; copiousoutput

      # Images
      image/*; ${pkgs.feh}/bin/feh %s
    '';

    programs.neomutt = {
      enable = true;
      vimKeys = true; # Breaks things

      # Inspired by 
      # https://seniormars.com/posts/neomutt/
      extraConfig = concatStrings [ ''
        set editor = "nvim"

        # Sync mailbox automatically
        # startup-hook '`systemctl --user start mailSync.timer`'
        # shutdown-hook '`systemctl --user stop mailSync.timer`'
        set mail_check = ${toString syncIntervalSeconds}

        # Notmuch
        # set query_command = "notmuch address %s"
        set query_command = "echo "" && notmuch address from:/%s/"

        set query_format="%4c %t %-70.70a %-70.70n %?e?(%e)?"
        bind editor <Tab> complete-query
        bind editor ^T complete

        # Mailcap for MIME types
        set mailcap_path = "~/.config/mailcap"
        auto_view text/html
        alternative_order text/plain text/html

        # sidebar
        set sidebar_visible = yes
        set sidebar_width = 22
        set sidebar_short_path = yes
        set sidebar_next_new_wrap = yes
        set mail_check_stats
        set sidebar_format = '%B%?F? [%F]?%* %?N?%N/? %?S?%S?'
        bind index,pager B sidebar-toggle-visible

        # settings
        set pager_index_lines = 10          
        set pager_context = 3                # show 3 lines of context
        set pager_stop                       # stop at end of message
        set menu_scroll                      # scroll menu
        set tilde                            # use ~ to pad mutt
        set move=no                          # don't move messages when marking as read
        # set imap_keepalive = 900             # 15 minutes
        set sleep_time = 0                   # don't sleep when idle
        set wait_key = no		     # mutt won't ask "press key to continue"
        set envelope_from                    # which from?
        set edit_headers                     # show headers when composing
        set fast_reply                       # skip to compose when replying
        set askcc                            # ask for CC:
        set fcc_attach                       # save attachments with the body
        set forward_format = "Fwd: %s"       # format of subject when forwarding
        set forward_decode                   # decode when forwarding
        set forward_quote                    # include message in forwards
        set mime_forward                     # forward attachments as part of body
        set attribution = "On %d, %n wrote:" # format of quoting header
        set reply_to                         # reply to Reply to: field
        set reverse_name                     # reply as whomever it was to
        set include                          # include message in replies
        set text_flowed=yes                  # correct indentation for plain text
        unset sig_dashes                     # no dashes before sig
        unset markers

        # Sort by newest conversation first.
        set charset = "utf-8"
        set uncollapse_jump
        set sort_re
        set sort = reverse-threads
        set sort_aux = last-date-received
        # How we reply and quote emails.
        set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"
        set quote_regexp = "^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"
        set send_charset = "utf-8:iso-8859-1:us-ascii" # send in utf-8
      '' 
        (builtins.readFile ./themes/seniormars)
      ];
    };
  };
}
