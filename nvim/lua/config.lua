vim.g.mapleader = "<SPACE>"
vim.o.syntax = 'enable'
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.o.nu = true
vim.o.rnu = true
vim.o.clipboard = 'unnamedplus'
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.hidden = true
vim.o.mouse = 'a'
vim.o.smarttab = true
vim.bo.smartindent = true
vim.bo.autoindent = true
vim.o.autochdir = true
vim.g.mapleader = ' '
vim.o.autochdir = true
vim.opt.termguicolors = true
vim.g.cmdheight = 2
vim.g.pumheight = 10
vim.g.pumwidth = 12
vim.o.wrap = false
vim.g.scrolloff = 8
vim.g.scrollopt = 8
vim.w.conceallevel = 0

-- i dont like the INSERT thing
vim.cmd("set noshowmode")
-- Always show tabs
vim.cmd("set showtabline=2")

-- local cfg = vim.fn.stdpath('config')
-- Flush = function()
--     local s = vim.api.nvim_buf_get_name(0)
--     if string.match(s, '^' .. cfg .. '*') == nil then
--         return
--     end
--     s = string.sub(s, 6 + string.len(cfg), -5)
--     local val = string.gsub(s, '%/', '.')
--     package.loaded[val] = nil
-- end

-- vim.cmd('let mapleader = "<SPACE>"')
--vim.cmd("autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown")

-- =================
-- nvim commentary

require('nvim_comment').setup()

-- ==============
-- gitsigns setup

require('gitsigns').setup()

-- ===============================
-- config for telescope media files

require('telescope').load_extension('media_files')
require('telescope').setup {
  extensions = {
    media_files = {
      filetypes = {"png", "webp", "jpg", "jpeg", "pdf"}, -- for some reason the ico files don't work :(
      find_cmd = "rg"
    }
  },
}

-- =============
-- emmet config

-- enable emmet just for html and css
vim.cmd[[let g:user_emmet_install_global = 0]]
vim.cmd[[autocmd FileType html,css EmmetInstall]]

-- redefine trigger keywords
vim.cmd[[let g:user_emmet_leader_key='<C-L>']]


-- ======================
-- bufferline setup

require("bufferline").setup {}

-- things for LSP completion and whatever
-- ========================================================

-- Set completeopt to have a better completion experience
-- vim.o.completeopt = 'menuone,noselect'

-- luasnip setup bcz you need snipzzzzzzzzz
local luasnip = require 'luasnip'

local lspkind = require 'lspkind'

-- ================ NEW CONFIG FOR CMP ==============

  -- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
  completion = {
    completeopt = "menu,menuone,noselect"
  },
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = {
    -- ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
    -- ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm { 
      behavior = cmp.ConfirmBehavior.Replace,
      select = true 
    },
    ["<Tab>"] = function(fallback)
       if cmp.visible() then
          cmp.select_next_item()
       elseif require("luasnip").expand_or_jumpable() then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
       else
          fallback()
       end
    end,
    ["<S-Tab>"] = function(fallback)
       if cmp.visible() then
          cmp.select_prev_item()
       elseif require("luasnip").jumpable(-1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
       else
          fallback()
       end
    end,
  },
  formatting = {
    -- format = lspkind.cmp_format({with_text = true, maxwidth = 50}),
     format = function(entry, vim_item)
       -- make menu smaller
       vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
       -- load lspkind icons
       vim_item.kind = string.format(
          "%s %s",
          require("lspkind_icons").icons[vim_item.kind],
          vim_item.kind
       )

       vim_item.menu = ({
          nvim_lsp = "[LSP]",
          nvim_lua = "[Lua]",
          buffer = "[Buffer]",
          path = "[Path]"
       })[entry.source.name]

       return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'buffer' },
    { name = 'nvim_lua' },
    { name = 'path' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }),
  experimental = {
    ghost_text = true
  }
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })

-- Setup lspconfig.
local lsp_installer = require("nvim-lsp-installer")
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['ccls'].setup {
  capabilities = capabilities
}


-- lsp_installer.on_server_ready(function(server))
--   local opts = {
--     capabilities=capabilities
--   }
-- end

-- ================ OLD CONFIG FOR CMP ==============
-- nvim-cmp setup
-- local present, cmp = pcall(require, 'cmp')
-- 
-- if not present then
--   return
-- end

-- vim.opt.completeopt = "menuone,noseletc" --maybe not

-- nvim-cmp setup
-- cmp.setup {
--   snippet = {
--     expand = function(args)
--       require('luasnip').lsp_expand(args.body)
--     end,
--   },
--   mapping = {
--     -- antes era <C-p> pra previous
--     -- e <C-n> pra next
--     ['<S-Tab>'] = cmp.mapping.select_prev_item(),
--     ['<Tab>'] = cmp.mapping.select_next_item(),
--     ['<C-d>'] = cmp.mapping.scroll_docs(-4),
--     ['<C-f>'] = cmp.mapping.scroll_docs(4),
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<C-e>'] = cmp.mapping.close(),
--     ['<CR>'] = cmp.mapping.confirm {
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     },
--     -- ['<Tab>'] = function(fallback)
--     --   if vim.fn.pumvisible() == 1 then
--     --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
--     --   elseif luasnip.expand_or_jumpable() then
--     --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
--     --   else
--     --     fallback()
--     --   end
--     -- end,
--     -- ['<S-Tab>'] = function(fallback)
--     --   if vim.fn.pumvisible() == 1 then
--     --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
--     --   elseif luasnip.jumpable(-1) then
--     --     vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
--     --   else
--     --     fallback()
--     --   end
--     -- end,
--   },
--   formatting = {
--      format = function(entry, vim_item)
--        -- make menu smaller
--        vim_item.abbr = string.sub(vim_item.abbr, 1, 20)
--        -- load lspkind icons
--        vim_item.kind = string.format(
--           "%s %s",
--           require("lspkind_icons").icons[vim_item.kind],
--           vim_item.kind
--        )
-- 
--        vim_item.menu = ({
--           nvim_lsp = "[LSP]",
--           nvim_lua = "[Lua]",
--           buffer = "[BUF]",
--        })[entry.source.name]
-- 
--        return vim_item
--     end,
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--     { name = 'luasnip' },
--   },
-- }
--
-- =============== NEW CONFIG FOR LSP =================

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)
--   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

local function on_attach(_, bufnr)
   local function buf_set_keymap(...)
      vim.api.nvim_buf_set_keymap(bufnr, ...)
   end
   local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
   end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.documentationFormat = { "markdown", "plaintext", "css", "html" }
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.preselectSupport = true
capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
capabilities.textDocument.completion.completionItem.deprecatedSupport = true
capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
capabilities.textDocument.completion.completionItem.resolveSupport = {
   properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
   },
}

-- replace the default lsp diagnostic symbols
local function lspSymbol(name, icon)
   vim.fn.sign_define("LspDiagnosticsSign" .. name, { text = icon, numhl = "LspDiagnosticsDefault" .. name })
end

lspSymbol("Error", "")
lspSymbol("Information", "")
lspSymbol("Hint", "")
lspSymbol("Warning", "")

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
   virtual_text = {
      prefix = "",
      spacing = 0,
   },
   signs = true,
   underline = true,
   update_in_insert = false, -- update diagnostics insert mode
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
   border = "single",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
   border = "single",
})


-- =============== OLD CONFIG =================
-- local nvim_lsp = require('lspconfig')
-- 
-- -- Use an on_attach function to only map the following keys
-- -- after the language server attaches to the current buffer
-- local on_attach = function(client, bufnr)
--   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
--   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
-- 
-- 
--   -- Enable completion triggered by <c-x><c-o>
--   buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
-- 
--   -- Mappings.
--   local opts = { noremap=true, silent=true }
-- 
--   -- See `:help vim.lsp.*` for documentation on any of the below functions
--   buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
--   buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
--   buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
--   buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
--   buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
--   buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
--   buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
--   buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
--   buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
--   buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
--   buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
--   buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
--   buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
--   buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
--   buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
--   buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
--   buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
-- 
-- end
-- 
-- -- replace the default lsp diagnostic symbols
-- local function lspSymbol(name, icon)
--    vim.fn.sign_define("LspDiagnosticsSign" .. name, { text = icon, numhl = "LspDiagnosticsDefault" .. name })
-- end
-- 
-- lspSymbol("Error", "")
-- lspSymbol("Information", "")
-- lspSymbol("Hint", "")
-- lspSymbol("Warning", "")
-- 
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--    virtual_text = {
--       prefix = "",
--       spacing = 0,
--    },
--    signs = true,
--    underline = true,
--    update_in_insert = false, -- update diagnostics insert mode
-- })
-- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
--    border = "single",
-- })
-- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
--    border = "single",
-- })
-- 

-- ============== LANGUAGE SERVERS CONFIG ==================
-- ccls config for c and cpp completion
require'lspconfig'.ccls.setup{}

local lspconfig = require'lspconfig'
lspconfig.ccls.setup {
  init_options = {
    compilationDatabaseDirectory = "build";
    filetypes = { "c", "cpp" };
    root_dir = {"compile_commands.json", ".ccls", "compile_flags.txt", ".git", ".ccls-cache" };
    index = {
      threads = 0;
    };
    clang = {
      excludeArgs = { "-frounding-math"};
    };
  };
}

-- tsserver config for js and ts files
require'lspconfig'.tsserver.setup{ on_attach=on_attach }

-- pyright for python things
require'lspconfig'.pyright.setup{}

-- setup for cssls

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.cssls.setup {
  capabilities = capabilities
}

lsp_installer.on_server_ready(function(server)
  local opts = {
    capabilities = capabilities
  }
end)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches

local servers = { 'ccls', 'tsserver', 'pyright', 'cssls' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
-- 
-- -- thing for lsp install
-- 
-- require'lspinstall'.setup() -- important
-- 
-- local servers = require'lspinstall'.installed_servers()
-- for _, server in pairs(servers) do
--   require'lspconfig'[server].setup{}
-- end
-- 
-- config for treesitter to make things look good
-- with good highlight

local present, ts_config = pcall(require, "nvim-treesitter.configs")
if not present then
   return
end

ts_config.setup {
   ensure_installed = {
      "lua",
   },
   highlight = {
      enable = true,
      use_languagetree = true,
   },
   indent = {
     disable = { 'c', 'cpp', 'html', 'hs' },
     enable = true,
   },
}

-- ===============================================
-- prettier config

-- none of these seem to work :(
-- vim.cmd[[let g:prettier#config#use_tabs = 'auto']]
-- vim.cmd[[let g:prettier#config#tab_width = '2']]

-- ===============================================
-- null-ls config

-- local null_ls = require("null-ls")
-- 
-- -- register the number of sources simultaneously
-- local sources = {
--   null_ls.bultins.formatting.prettier.with({
--     filetypes = { "css", "json" },
--   }),
-- }
-- 
-- null_ls.config({ sources = sources })


-- require("null-ls").config({
--   sources = { require("null-ls").builtins.formatting.prettier.with({
--     filetipes = { "css", "json" },
--   }), }
-- })
-- 
-- require("lspconfig")["null-ls"].setup({
--   on_attach = my_custom_on_attach
-- })


-- local sources = { null_ls.builtins.formatting.prettier }


local prettier = function()
  return {
    exe = "prettier",
      args = {
        "--stdin-filepath",
        "--config .prettierrc",
        vim.api.nvim_buf_get_name(0)
      },
    stdin = true
  }
end

require('formatter').setup({
  logging = false,
  filetype = {
    css = { prettier },
    -- less = { prettier },
    -- scss = { prettier },
    -- sass = { prettier },
    html = { prettier }
  }
})

vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.css,*.html FormatWrite
augroup END
  ]], true
)
