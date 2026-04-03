{ ifIsEnabled, ... }:
let
  domain = "https://ollama.deamicis.top";
in
{
  plugins.minuet = {
    enable = true;

    # https://github.com/milanglacier/minuet-ai.nvim?tab=readme-ov-file
    settings = {
      # Qwen2.5-coder setup
      provider = "openai_fim_compatible";

      # recommend for local model for resource saving
      n_completions = 1;

      # If completion item has multiple lines, create another completion item
      # only containing its first line. This option only has impact for cmp and
      # blink. For virtualtext, no single line entry will be added.
      add_single_line_entry = true;

      # I recommend beginning with a small context window size and incrementally
      # expanding it, depending on your local computing power. A context window
      # of 512, serves as an good starting point to estimate your computing
      # power. Once you have a reliable estimate of your local computing power,
      # you should adjust the context window to a larger value.
      context_window = 8192;

      provider_options = {
        openai_fim_compatible = {
          # For Windows users, TERM may not be present in environment variables.
          # Consider using APPDATA instead.
          api_key = "TERM";
          name = "Ollama";
          end_point = "${domain}/v1/completions";
          model = "qwen2.5-coder:3b";
          optional = {
            max_tokens = 512;
            top_p = 0.9;
          };
        };
      };
    };
  };

  plugins.web-devicons.settings = ifIsEnabled {
    override = {
      "Ollama" = {
        icon = "󰡙";
        # https://www.color-hex.com/color-palette/94650
        color = "#fbf5de";
        name = "Ollama";
      };
    };
  };

  plugins.blink-cmp.settings = ifIsEnabled {
    # keymap = {
    #   # Manually invoke minuet completion.
    #   "<A-e>" = ''require("minuet").make_blink_map()'';
    # };

    appearance = {
      # use_nvim_cmp_as_default = true;
      # nerd_font_variant = "mono";
      nerd_font_variant = "normal";

      kind_icons =
        let
          # icon = "";
          icon = "󰡙";
          # icon = "Ollama";
        in
        {
          claude = icon;
          openai = icon;
          codestral = icon;
          gemini = icon;
          Groq = icon;
          Openrouter = icon;
          Ollama = icon;
          Deepseek = icon;

          # claude = "󰋦";
          # openai = "󱢆";
          # codestral = "󱎥";
          # gemini = "";
          # Groq = "";
          # Openrouter = "󱂇";
          # Ollama = "󰳆";
          # # ["Llama.cpp"] = "󰳆";
          # Deepseek = "";
        };
    };

    sources = {
      # Enable minuet for autocomplete
      default = [
        "lsp"
        "path"
        "buffer"
        "snippets"
        "minuet"
      ];

      # For manual completion only, remove 'minuet' from default
      providers = {
        minuet = {
          name = "minuet";
          module = "minuet.blink";
          async = true;
          # Should match minuet.config.request_timeout * 1000,
          # since minuet.config.request_timeout is in seconds
          timeout_ms = 3000;
          score_offset = 50; # Gives minuet higher priority among suggestions
        };
      };
    };

    # Recommended to avoid unnecessary request
    completion = {
      trigger = {
        prefetch_on_insert = false;
      };
    };
  };
}
