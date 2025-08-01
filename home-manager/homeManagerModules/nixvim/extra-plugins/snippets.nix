{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      friendly-snippets.enable = true;
      luasnip.enable = true;

      telescope.enabledExtensions = [
        "luasnip"
      ];
    };

    extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
      name = "telescope-luasnip";

      src = pkgs.fetchFromGitHub {
        owner = "benfowler";
        repo = "telescope-luasnip.nvim";
        rev = "07a2a2936a7557404c782dba021ac0a03165b343";
        sha256 = "9XsV2hPjt05q+y5FiSbKYYXnznDKYOsDwsVmfskYd3M=";
      };
    })];
  };
}
