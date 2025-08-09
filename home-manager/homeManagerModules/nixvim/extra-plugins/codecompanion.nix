let
  domain = "https://ollama.deamicis.top";
in
{
  programs.nixvim.plugins.codecompanion = {
    enable = false;

    settings = {
      adapters = {
        ollama = {
          __raw = ''
            function()
              return require('codecompanion.adapters').extend('ollama', {
                  env = {
                      url = "${domain}",
                  },
                  schema = {
                      model = {
                          default = 'qwen2.5-coder:latest',
                          -- default = "llama3.1:8b-instruct-q8_0",
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
}
