{ ifIsEnabled, ... }:
{
  plugins.auto-session = {
    enable = true;

    settings = {
      # Saving / restoring
      enabled = true; # Enables/disables auto creating, saving and restoring
      auto_save = true; # Enables/disables auto saving session on exit
      auto_restore = true; # Enables/disables auto restoring session on start
      auto_create = true; # Enables/disables auto creating new session files. Can be a function that returns true if a new session file should be allowed
      auto_restore_last_session = false; # On startup, loads the last saved session if session for cwd does not exist
      cwd_change_handling = true; # Automatically save/restore sessions when changing directories
      single_session_mode = false; # Enable single session mode to keep all work in one session regardless of cwd changes. When enabled, prevents creation of separate sessions for different directories and maintains one unified session. Does not work with cwd_change_handling

      # Filtering
      suppressed_dirs = null; # Suppress session restore/create in certain directories
      allowed_dirs = null; # Allow session restore/create in certain directories
      bypass_save_filetypes = null; # List of filetypes to bypass auto save when the only buffer open is one of the file types listed, useful to ignore dashboards
      close_filetypes_on_save = [ "checkhealth" ]; # Buffers with matching filetypes will be closed before saving
      close_unsupported_windows = true; # Close windows that aren't backed by normal file before autosaving a session
      preserve_buffer_on_restore = null; # Function that returns true if a buffer should be preserved when restoring a session

      # Git / Session naming
      git_use_branch_name = true; # Include git branch name in session name, can also be a function that takes an optional path and returns the name of the branch
      git_auto_restore_on_branch_change = true; # Should we auto-restore the session when the git branch changes. Requires git_use_branch_name
      # custom_session_tag = null; # Function that can return a string to be used as part of the session name

      # Deleting
      auto_delete_empty_sessions = true; # Enables/disables deleting the session if there are only unnamed/empty buffers when auto-saving
      purge_after_minutes = 4320; # Sessions older than purge_after_minutes will be deleted asynchronously on startup, e.g. set to 14400 to delete sessions that haven't been accessed for more than 10 days, defaults to off (no purging), requires >= nvim 0.10
    };
  };

  plugins.telescope.keymaps."<leader>fr" = ifIsEnabled "session-lens";
}
