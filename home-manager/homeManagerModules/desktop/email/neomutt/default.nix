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

    theme = mkOption {
      type = types.str;
      default = "catppuccin";
    };
  };

  config = mkIf cfg.enable {
    accounts.email.accounts = {
      "dashingkoso@deamicis.top".neomutt.enable = true;
      "dashingkoso@gmail.com".neomutt.enable = true;
      "ldeamicis12@gmail.com".neomutt.enable = true;
    };

    programs.neomutt = {
      enable = true;
      vimKeys = true;
      # checkStatsInterval = 60;
      # sidebar = {
      #   enable = true;
      #   width = 30;
      # };

      # extraConfig = builtins.readFile ./themes/${cfg.theme};

      # Inspired by 
      # https://seniormars.com/posts/neomutt/
      extraConfig = concatStrings [ ''
        set editor = "nvim"

        #sidebar
        set sidebar_visible # comment to disable sidebar by default
        set sidebar_short_path
        set sidebar_folder_indent
        set sidebar_format = "%D %* [%?N?%N / ?%S]"
        set mail_check_stats
        bind index,pager \CJ sidebar-prev
        bind index,pager \CK sidebar-next
        bind index,pager \CE sidebar-open
        bind index,pager B sidebar-toggle-visible

        # settings
        set pager_index_lines = 10          
        set pager_context = 3                # show 3 lines of context
        set pager_stop                       # stop at end of message
        set menu_scroll                      # scroll menu
        set tilde                            # use ~ to pad mutt
        set move=no                          # don't move messages when marking as read
        set mail_check = 30                  # check for new mail every 30 seconds
        set imap_keepalive = 900             # 15 minutes
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
