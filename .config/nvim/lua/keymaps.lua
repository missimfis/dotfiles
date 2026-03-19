-- keymaps.lua - Minimal Fast Keymaps

local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc, silent = true })
end
local imap = function(lhs, rhs, desc)
  vim.keymap.set('i', lhs, rhs, { desc = desc, silent = true })
end
local vmap = function(lhs, rhs, desc)
  vim.keymap.set('v', lhs, rhs, { desc = desc, silent = true })
end

-- Save/Quit
nmap('<leader>w', '<cmd>update<CR>', 'Save')
nmap('<leader>q', '<cmd>q<CR>', 'Quit')
nmap('<leader>x', '<cmd>bd<CR>', 'Delete buffer')

-- Windows
nmap('<C-h>', '<cmd>wincmd h<CR>', 'Left')
nmap('<C-j>', '<cmd>wincmd j<CR>', 'Down')
nmap('<C-k>', '<cmd>wincmd k<CR>', 'Up')
nmap('<C-l>', '<cmd>wincmd l<CR>', 'Right')
nmap('<C-w>', '<cmd>wincmd w<CR>', 'Next')

-- Tabs
nmap('<leader>tn', '<cmd>tabnew<CR>', 'New tab')
nmap('<leader>tq', '<cmd>tabclose<CR>', 'Close tab')
nmap('<leader>th', '<cmd>tabprevious<CR>', 'Prev tab')
nmap('<leader>tl', '<cmd>tabnext<CR>', 'Next tab')

-- Buffers
nmap('<leader>bn', '<cmd>bn<CR>', 'Next buffer')
nmap('<leader>bp', '<cmd>bp<CR>', 'Prev buffer')

-- FZF Fuzzy
nmap('<leader>ff', '<cmd>FzfLua files<CR>', 'Find files')
nmap('<leader>fg', '<cmd>FzfLua live_grep<CR>', 'Live grep')
nmap('<leader>fb', '<cmd>FzfLua buffers<CR>', 'Buffers')
nmap('<leader>fh', '<cmd>FzfLua help_tags<CR>', 'Help')
nmap('<leader>fc', '<cmd>FzfLua colorscheme<CR>', 'Colorscheme')
nmap('<leader>fr', '<cmd>FzfLua resume<CR>', 'Resume')

-- LSP
nmap('gd', vim.lsp.buf.definition, 'Definition')
nmap('gr', vim.lsp.buf.references, 'References')
nmap('K', vim.lsp.buf.hover, 'Hover')
nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
nmap('<leader>ca', vim.lsp.buf.code_action, 'Code action')
nmap(']d', vim.diagnostic.goto_next, 'Next diagnostic')
nmap('[d', vim.diagnostic.goto_prev, 'Prev diagnostic')
nmap('<leader>rf', function() require('conform').format({ async = true }) end, 'Format')

-- Search
nmap('n', 'nzzzv', 'Next search')
nmap('N', 'Nzzzv', 'Prev search')
nmap('<leader><space>', '<cmd>noh<CR>', 'Clear highlights')

-- Move
vmap('J', ":m '>+1<CR>gv=gv", 'Move down')
vmap('K', ":m '<-2<CR>gv=gv", 'Move up')
vmap('<', '<gv', 'Indent left')
vmap('>', '>gv', 'Indent right')

-- Quick escape
imap('jk', '<Esc>', 'Escape')
imap('kj', '<Esc>', 'Escape')

-- Leap motions
nmap('s', '<cmd>Leap<CR>', 'Leap')
nmap('S', '<cmd>LeapFromWindow<CR>', 'Leap from window')

-- Git
nmap('<leader>gd', '<cmd>Git diff<CR>', 'Git diff')
nmap('<leader>gc', '<cmd>Git commit<CR>', 'Git commit')
nmap('<leader>gp', '<cmd>Git push<CR>', 'Git push')

-- Clipboard
nmap('gy', '"+y', 'Yank to clipboard')
nmap('gp', '"+p', 'Paste from clipboard')
vmap('gy', '"+y', 'Yank to clipboard')
vmap('gp', '"+p', 'Paste from clipboard')

-- Misc
nmap('<leader>ot', function()
  vim.cmd([[%s/\s\+$//e]])
end, 'Trim trailing space')

vim.cmd([[
  augroup FastStartup
    autocmd!
    autocmd User LazyDone ++once lua require('lualine').setup({ options = { theme = 'nord' } })
  augroup END
]])
