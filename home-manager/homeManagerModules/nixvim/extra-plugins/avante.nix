let
  domain = "https://ollama.deamicis.top";
in
{
  programs.nixvim.plugins.avante = {
    enable = false;

    settings = {
      provider = "ollama";
      providers.ollama = {
        model = "qwen2.5-coder";
        endpoint = "${domain}/api";
      };

      diff = {
        autojump = true;
        debug = true;
        list_opener = "copen";
      };

      highlights = {
        diff = {
          current = "DiffText";
          incoming = "DiffAdd";
        };
      };

      mappings = {
        # ask = "<leader>sa";
        # edit = "<leader>se";
        diff = {
          both = "cb";
          next = "]x";
          none = "c0";
          ours = "co";
          prev = "[x";
          theirs = "ct";
        };
      };

      hints = {
        enabled = true;
      };

      windows = {
        sidebar_header = {
          align = "center";
          rounded = true;
        };
        width = 30;
        wrap = true;
      };
    };
  };
}
