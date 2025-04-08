{
  programs.nixvim.plugins.avante = {
    enable = false;

    settings = {
      provider = "ollama";
      ollama = {
        model = "qwen-coder2.5";
        endpoint = "http://192.168.0.165:47300";
      };

      diff = {
        autojump = true;
        debug = false;
        list_opener = "copen";
      };

      highlights = {
        diff = {
          current = "DiffText";
          incoming = "DiffAdd";
        };
      };

      # mappings = {
      #   diff = {
      #     both = "cb";
      #     next = "]x";
      #     none = "c0";
      #     ours = "co";
      #     prev = "[x";
      #     theirs = "ct";
      #   };
      # };
      #
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
