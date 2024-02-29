return {
  "glepnir/lspsaga.nvim",
  event = "BufRead",
  config = function()
    require("lspsaga").setup({
      symbol_in_winbar = {
        enable = true,
      },
      ui = {
        hover = " ",
      },
    })
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
