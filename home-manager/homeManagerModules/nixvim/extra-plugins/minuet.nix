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

      # I recommend beginning with a small context window size and incrementally
      # expanding it, depending on your local computing power. A context window
      # of 512, serves as an good starting point to estimate your computing
      # power. Once you have a reliable estimate of your local computing power,
      # you should adjust the context window to a larger value.
      context_window = 512;

      provider_options = {
        openai_fim_compatible = {
          # For Windows users, TERM may not be present in environment variables.
          # Consider using APPDATA instead.
          api_key = "TERM";
          name = "Ollama";
          end_point = "${domain}/v1/completions";
          model = "qwen2.5-coder:3b";
          optional = {
            max_tokens = 56;
            top_p = 0.9;
          };
        };
      };
    };
  };

  plugins.blink-cmp.settings = ifIsEnabled {
    # keymap = {
    #   # Manually invoke minuet completion.
    #   "<A-e>" = ''require("minuet").make_blink_map()'';
    # };

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
