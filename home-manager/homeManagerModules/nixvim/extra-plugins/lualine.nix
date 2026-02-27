{
  plugins.lualine = {
    enable = true;

    settings.__raw = ''
      {
        options = {
          globalstatus = true,
        },
        sections = {
          lualine_x = {
            "encoding",
            "filetype",
            {
              function()
                local nix = os.getenv("IN_NIX_SHELL")
                if nix then
                  return nix
                else
                  return ""
                end
              end,

              -- icon = {"", color = {fg = "lightblue"}},
            },
            "fileformat",
          },
        },
      }
    '';
  };
}
