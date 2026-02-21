{
  plugins.render-markdown = {
    enable = true;
    settings.file_types = [
      "markdown"
      "codecompanion"
    ];

    lazyLoad.settings = {
      ft = "markdown";
    };
  };
}
