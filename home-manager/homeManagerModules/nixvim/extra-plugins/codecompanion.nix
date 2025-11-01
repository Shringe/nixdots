{ config, lib, ... }:
with lib;
let
  domain = "https://ollama.deamicis.top";
  # model = "qwen2.5-coder:latest";
  model = "deepseek-r1:latest";
  enable = false;
in
{
  sops.secrets."llm/openai" = mkIf enable { };

  programs.nixvim = mkIf enable {
    plugins.codecompanion = {
      enable = true;

      settings = {
        http.adapters = {
          ollama.__raw = ''
            function()
              return require("codecompanion.adapters").extend("ollama", {
                  env = {
                      url = "${domain}",
                  },
                  schema = {
                      model = {
                          default = "${model}",
                      },
                      num_ctx = {
                          default = 32768,
                      },
                  },
              })
            end
          '';

          openai.__raw = ''
            function()
              return require("codecompanion.adapters").extend("openai", {
                  env = {
                      api_key = "cmd:cat ${config.sops.secrets."llm/openai".path}",
                  },
                  schema = {
                      model = {
                          default = "gpt-5-mini",
                      },
                      -- num_ctx = {
                      --     default = 32768,
                      -- },
                  },
              })
            end
          '';
        };

        http.opts = {
          log_level = "TRACE";
          send_code = true;
          use_default_actions = true;
          use_default_prompts = true;
        };

        strategies = {
          agent = {
            adapter = "ollama";
          };

          chat = {
            adapter = "ollama";
          };

          inline = {
            adapter = "ollama";
          };
        };
      };
    };

    keymaps = [
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>ss";
        action = "<cmd>CodeCompanion<CR>";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>sa";
        action = "<cmd>CodeCompanionActions<CR>";
      }
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>st";
        action = "<cmd>CodeCompanionChat Toggle<CR>";
      }
    ];
  };
}
