let
  domain = "https://ollama.deamicis.top";
  # model = "qwen2.5-coder:latest";
  model = "deepseek-r1:latest";
in
{
  programs.nixvim = {
    plugins.codecompanion = {
      enable = true;

      settings = {
        adapters = {
          ollama = {
            __raw = ''
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
          };
        };

        opts = {
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
        action = "<cmd>CodeCompanionChat<CR>";
      }
    ];
  };
}
