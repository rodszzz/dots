require('packer').startup(function()
  -- use 'morhetz/gruvbox'
  use 'jiangmiao/auto-pairs'
  use 'tpope/vim-commentary'
  -- use 'Yagua/nebulous.nvim'
  use 'marko-cerovac/material.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpadate'
  }

  -- thing for lsp
  use 'neovim/nvim-lspconfig' -- language server protocol
  use 'kabouzeid/nvim-lspinstall' -- install language servers easily
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
end)

-- lembrar de refazer tudo desse jeito aqui
-- return {
--   { "wbthomason/packer.nvim" },
--   { "neovim/nvim-lspconfig" },
--   { "kabouzeid/nvim-lspinstall" },
-- }
