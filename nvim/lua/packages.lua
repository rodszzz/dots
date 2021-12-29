require('packer').startup(function()
  use 'terrortylor/nvim-comment'
  use 'jiangmiao/auto-pairs'
  use 'marko-cerovac/material.nvim'
  use 'mattn/emmet-vim'
  -- use 'shaunsingh/solarized.nvim'
  use 'shatur/neovim-ayu'

  use 'edeneast/nightfox.nvim'

  -- use 'prettier/vim-prettier'

  -- use 'jose-elias-alvarez/null-ls.nvim'

  use {
    'ellisonleao/gruvbox.nvim',
    requires = {'rktjmp/lush.nvim'}
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}, {'nvim-telescope/telescope-media-files.nvim'}}
  }

  -- use {
  --   'nvim-treesitter/nvim-treesitter',
  --   run = ':TSUpadate'
  -- }

  use 'nvim-treesitter/nvim-treesitter'

  use {
    'akinsho/bufferline.nvim',
    requires = 'kyazdani42/nvim-web-devicons'
  }

  use {
  'lewis6991/gitsigns.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  } }

  -- thing for lsp

  use 'neovim/nvim-lspconfig' -- language server protocol
  use 'kabouzeid/nvim-lspinstall' -- install language servers easily
  use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'onsails/lspkind-nvim'
  use 'williamboman/nvim-lsp-installer'

  use 'mhartington/formatter.nvim'
end)

-- lembrar de refazer tudo desse jeito aqui
-- return {
--   { "wbthomason/packer.nvim" },
--   { "neovim/nvim-lspconfig" },
--   { "kabouzeid/nvim-lspinstall" },
-- }
