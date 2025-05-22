{
  programs.nixvim.plugins.transparent = {
    enable = true;
    settings = {
      groups = [
        "Normal"
        "NormalNC"
        "Comment"
        "Constant"
        "Special"
        "Identifier"
        "Statement"
        "PreProc"
        "Type"
        "Underlined"
        "Todo"
        "String"
        "Function"
        "Conditional"
        "Repeat"
        "Operator"
        "Structure"
        "LineNr"
        "NonText"
        "SignColumn"
        "CursorLine"
        "CursorLineNr"
        "NvimTreeNormal"
        "StatusLine"
        "StatusLineNC"
        "EndOfBuffer"
      ];
    };
  };
}
