return {
  "max397574/better-escape.nvim",
  config = function()
    require("better_escape").setup({
      mapping = { "jk", "JK" },
      timeout = vim.o.timeoutlen,
      clear_empty_lines = false,
      keys = "<ESC>",
    })
  end,
}
