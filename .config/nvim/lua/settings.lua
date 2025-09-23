-- --------------------------------------------------------------
--  UI options, keymaps, and miscellaneous settings
-- --------------------------------------------------------------

local set = vim.opt
local map = vim.keymap.set

-- ------------ General editing options (already in init.lua) ----------
-- (kept here for readability – you can move any you like)

set.expandtab      = true
set.shiftwidth     = 2
set.tabstop        = 2
set.smartindent    = true
set.mouse          = 'a'
set.clipboard=unnamedplus
vim.opt.relativenumber = true

-- ------------ Leader key ------------------------------------------------
vim.g.mapleader = ' '

-- ------------ Keymaps ----------------------------------------------------
-- Normal mode shortcuts
map('n', '<leader>e',  ':Oil<CR>',               { desc = 'Open file explorer (Oil)' })
map('n', '<leader>ff', function() require('telescope.builtin').find_files() end,
    { desc = 'Find files (Telescope)' })
map('n', '<leader>lg', function() require('telescope.builtin').live_grep() end,
    { desc = 'Live grep (Telescope)' })
map('n', '<leader>gb', function() require('telescope.builtin').git_branches() end,
    { desc = 'Git branches' })
map('n', '<leader>gc', function() require('telescope.builtin').git_commits() end,
    { desc = 'Git commits' })
map('n', '<leader>gs', function() require('telescope.builtin').git_status() end,
    { desc = 'Git status' })

-- Insert‑mode: use <C‑Space> to manually trigger completion
map('i', '<C-Space>', function() require('cmp').complete() end,
    { desc = 'Trigger completion' })

-- LSP specific shortcuts (added per‑buffer in lsp.lua's on_attach)
