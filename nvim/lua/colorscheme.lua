-- set the background color
-- "dark" // "light"
vim.o.background = "dark"

-- need this to make the background of
-- neovim tranparent
-- if you're using the material colorscheme
-- these 2 lines are not needed
vim.cmd[[au ColorScheme * hi Normal ctermbg=none guibg=none]]
vim.cmd[[au ColorScheme myspecialcolors hi Normal ctermbg=red guibg=red]]

-- =================================
-- config for material colorscheme

require('material').setup({
  contrast = true, -- Enable contrast for sidebars, floating windows and popup menus like Nvim-Tree
  borders = false, -- Enable borders between verticaly split windows

  italics = {
          comments = true, -- Enable italic comments
          keywords = true, -- Enable italic keywords
          functions = true, -- Enable italic functions
          strings = false, -- Enable italic strings
          variables = true -- Enable italic variables
  },

  contrast_windows = { -- Specify which windows get the contrasted (darker) background
          "terminal", -- Darker terminal background
          "packer", -- Darker packer background
          "qf" -- Darker qf list background
  },

  text_contrast = {
          lighter = true, -- Enable higher contrast text for lighter style
          darker = true -- Enable higher contrast text for darker style
  },

  disable = {
          background = true, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
          term_colors = false, -- Prevent the theme from setting terminal colors
          eob_lines = false -- Hide the end-of-buffer lines
  },

  -- custom_highlights = {} -- Overwrite highlights with your own
})

-- set the deep ocean colorscheme
-- others are oceanic, lighter darker palenight
vim.g.material_style = "deep ocean"


-- =================================
-- gruvbox colorscheme setup
-- for changing into gruvlight or gruvdark
-- change the "vim.o.background" to dark or light

-- ===========================
-- solarized light colorscheme
-- because it's nice to change things sometimes
-- (but gruvlight is WAY better than this)

-- require('solarized').set()
-- ===============
-- ayu colorscheme

require('ayu').setup({
  mirage = false,
  overrides = {},
})

-- nightfox config
-- local nightfox = require('nightfox')
-- 
-- -- This function set the configuration of nightfox. If a value is not passed in the setup function
-- -- it will be taken from the default configuration above
-- nightfox.setup({
--   fox = "duskfox", -- colorscheme (nightfox, nordfox, dayfox, dawnfox, duskfox)
--   styles = {
--     comments = "italic", -- change style of comments to be italic
--     keywords = "bold", -- change style of keywords to be bold
--     functions = "italic,bold" -- styles can be a comma separated list
--   },
--   inverse = {
--     match_paren = false, -- inverse the highlighting of match_parens
--   },
--   colors = {
--     red = "#FF000", -- Override the red color for MAX POWER
--     bg_alt = "#000000",
--   },
--   hlgroups = {
--     TSPunctDelimiter = { fg = "${red}" }, -- Override a highlight group with the color red
--     LspCodeLens = { bg = "#000000", style = "italic" },
--   }
-- })

-- Load the configuration set above and apply the colorscheme
-- nightfox.load()

-- finally set the colorscheme
-- options are:
-- ayu, ayu-dark, ayu-light, ayu-mirage
-- gruvbox, material, solarized
vim.cmd[[colorscheme material]]
