let
  mode = [
    # "t"
    "n"
  ];
in
{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        # direction = "float";
        direction = "vertical";
        size = 80;
      };

      luaConfig.post = ''
        local Terminal = require("toggleterm.terminal").Terminal

        local lazygit = Terminal:new({
          display_name = "Lazygit",
          cmd = "lazygit",
          hidden = true,
          direction = "float",
          on_open = function(term)
            vim.cmd.stopinsert()
          end,
        })

        local yazi = Terminal:new({
          display_name = "Yazi",
          cmd = "yazi",
          hidden = true,
          direction = "float",
          on_open = function(term)
            vim.cmd.stopinsert()
          end,
        })

        local shell = Terminal:new({
          display_name = "Shell",
          cmd = "nu",
          hidden = true,
          on_open = function(term)
            vim.cmd.stopinsert()
          end,
        })

        function _lazygit_toggle()
          lazygit:toggle()
        end

        function _yazi_toggle()
          yazi:toggle()
        end

        function _shell_toggle()
          shell:toggle()
        end
      '';

      lazyLoad.enable = false;
      lazyLoad.settings = {
        cmd = "ToggleTerm";
        keys = [
          "<leader>tt"
          "<leader>tl"
          "<leader>ty"
        ];
      };
    };

    keymaps = [
      {
        inherit mode;
        key = "<leader>tt";
        action = "<cmd>lua _shell_toggle()<CR>";
        options.silent = true;
      }
      {
        inherit mode;
        key = "<leader>tl";
        action = "<cmd>lua _lazygit_toggle()<CR>";
        options.silent = true;
      }
      {
        inherit mode;
        key = "<leader>ty";
        action = "<cmd>lua _yazi_toggle()<CR>";
        options.silent = true;
      }
    ];
  };
}
