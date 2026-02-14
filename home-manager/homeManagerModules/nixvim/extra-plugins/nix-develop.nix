{
  plugins.nix-develop = {
    enable = true;

    luaConfig.post = ''
      local original_nix_develop = require("nix-develop").nix_develop
      require("nix-develop").nix_develop = function(args)
        original_nix_develop(args)
        vim.defer_fn(vim.cmd.LspRestart, 1000)
      end

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.filereadable("flake.nix") == 1 then
            vim.cmd.NixDevelop()
          end
        end,
      })
    '';
  };
}
