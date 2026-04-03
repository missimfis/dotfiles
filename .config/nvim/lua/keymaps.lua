-- keymaps.lua - Minimal Fast Keymaps

local map = vim.keymap.set
local nmap = function(lhs, rhs, desc) map('n', lhs, rhs, { desc = desc, silent = true }) end
local imap = function(lhs, rhs, desc) map('i', lhs, rhs, { desc = desc, silent = true }) end
local vmap = function(lhs, rhs, desc) map('v', lhs, rhs, { desc = desc, silent = true }) end
local xmap = function(lhs, rhs, desc) map('x', lhs, rhs, { desc = desc, silent = true }) end

-- Save/Quit
nmap('<leader>w', '<cmd>update<CR>', 'Save')
nmap('<leader>q', '<cmd>q<CR>', 'Quit')
nmap('<leader>x', '<cmd>bd<CR>', 'Delete buffer')

-- Explorer
nmap('<leader>e', '<cmd>Oil<CR>', 'File explorer')

-- Windows
nmap('<C-h>', '<cmd>wincmd h<CR>', 'Left')
nmap('<C-j>', '<cmd>wincmd j<CR>', 'Down')
nmap('<C-k>', '<cmd>wincmd k<CR>', 'Up')
nmap('<C-l>', '<cmd>wincmd l<CR>', 'Right')

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

-- LSP (set via LspAttach autocmd for buffer-local safety)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspKeymaps', { clear = true }),
  callback = function(ev)
    local buf = function(lhs, rhs, d) map('n', lhs, rhs, { buffer = ev.buf, desc = d, silent = true }) end
    buf('gd', vim.lsp.buf.definition, 'Definition')
    buf('gr', vim.lsp.buf.references, 'References')
    buf('K', vim.lsp.buf.hover, 'Hover')
    buf('<leader>rn', vim.lsp.buf.rename, 'Rename')
    buf('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    buf(']d', vim.diagnostic.goto_next, 'Next diagnostic')
    buf('[d', vim.diagnostic.goto_prev, 'Prev diagnostic')
    buf('<leader>rf', function() require('conform').format({ async = true, bufnr = ev.buf }) end, 'Format')
    buf('gi', vim.lsp.buf.implementation, 'Implementation')
    buf('<leader>d', vim.diagnostic.open_float, 'Line diagnostics')
  end,
})

-- Search
nmap('n', 'nzzzv', 'Next search')
nmap('N', 'Nzzzv', 'Prev search')
nmap('<leader><space>', '<cmd>noh<CR>', 'Clear highlights')

-- Move lines (visual mode)
xmap('J', ":m '>+1<CR>gv=gv", 'Move down')
xmap('K', ":m '<-2<CR>gv=gv", 'Move up')
xmap('<', '<gv', 'Indent left')
xmap('>', '>gv', 'Indent right')

-- Quick escape
imap('jk', '<Esc>', 'Escape')
imap('kj', '<Esc>', 'Escape')

-- Leap motions (use gs/gS to avoid conflicting with vim-surround)
nmap('gs', '<cmd>Leap<CR>', 'Leap')
nmap('gS', '<cmd>LeapFromWindow<CR>', 'Leap from window')

-- Git
nmap('<leader>gd', '<cmd>Git diff<CR>', 'Git diff')
nmap('<leader>gc', '<cmd>Git commit<CR>', 'Git commit')
nmap('<leader>gp', '<cmd>Git push<CR>', 'Git push')

-- Clipboard (visual mode only to avoid gp conflict)
xmap('gy', '"+y', 'Yank to clipboard')
xmap('gP', '"+P', 'Paste from clipboard')
nmap('gY', '"+y', 'Yank to clipboard')
nmap('gP', '"+P', 'Paste from clipboard')

-- Misc
nmap('<leader>ot', function() vim.cmd([[%s/\s\+$//e]]) end, 'Trim trailing space')
