{
  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      DEFAULT = "https://seek.fyi/search?q={}";
      sx = "https://seek.fyi/search?q={}";
      sp = "https://www.startpage.com/en/search?q={}";
      aw = "https://wiki.archlinux.org/?search={}";
      nw = "https://wiki.nixos.org/index.php?search={}";
    };
  };
}
