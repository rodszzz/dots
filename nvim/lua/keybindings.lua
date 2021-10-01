local keymap = vim.api.nvim_set_keymap
keymap('i', 'jk', '<Esc>', {})
keymap('n', '<c-s>', ':w<CR>', {})
keymap('n', '<c-q>', ':q!<CR>', {})
keymap('n', '<TAB>', ':bnext<CR>', {})
keymap('v', '<', '<gv', {})
keymap('v', '>', '>gv', {})
keymap('n', ',ff', '<cmd>Telescope find_files<CR>', {})
keymap('n', ',bb', '<cmd>Telescope buffers<CR>', {})
keymap('n', ',nn', '<cmd>Telescope file_browser<CR>', {})
keymap('n', ',/', '<cmd>Commentary<CR>', {})
-- lembrar de ver um jeito melhor de fazer isso
