{
  plugins.marks = {
    enable = true;

    lazyLoad.settings = {
      # Could also wait until event = "BufNewFile", then keys = "m" to avoid loading on new buffers until the first mark
      event = [
        "BufReadPost"
        "BufNewFile"
      ];
    };
  };
}
