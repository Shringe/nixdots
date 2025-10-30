let
  mkTuiAppLua = cmd: ''
    local ${cmd} = Terminal:new({
      cmd = "${cmd}",
      hidden = true,
    })

    function _${cmd}_toggle()
      ${cmd}:toggle()
    end
  '';

  mkTuiAppKey = app: key: {
    mode = [
      "t"
      "n"
    ];

    key = key;
    action = "<cmd>lua _${app}_toggle()<CR>";
  };
in
{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        direction = "float";
      };

      luaConfig.post = ''
        local Terminal = require('toggleterm.terminal').Terminal
        ${mkTuiAppLua "lazygit"}
        ${mkTuiAppLua "yazi"}
      '';
    };

    keymaps = [
      {
        mode = [
          "t"
          "n"
        ];

        key = "<leader>tt";
        action = "<cmd>ToggleTerm<CR>";
      }
      (mkTuiAppKey "lazygit" "<leader>tl")
      (mkTuiAppKey "yazi" "<leader>ty")
    ];
  };
}
