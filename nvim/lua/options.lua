-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
-- thing that make words wrap
vim.opt.wrap = false

-- set spelling for english and portuguese
vim.cmd([[set spelllang=en,pt]])

-- Set highlight on search
vim.o.hlsearch = true

-- Make numbers default
vim.wo.number = true

-- toggle relative line numbers
vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.g.everforest_transparent_background = 2
vim.cmd([[colorscheme everforest]])
