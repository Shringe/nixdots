{
  programs.nixvim.plugins.llm = {
    enable = false;
    settings = {
      url = "http://192.168.0.165:47300";
      # model = "qwen2.5-coder";
      model = "codellama";
      backend = "ollama";
      # port =

      request_body = {
        options = {
          temperature = 0.2;
          top_p = 0.95;
        };
      };
    };
  };
}
