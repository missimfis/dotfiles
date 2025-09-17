-- --------------------------------------------------------------
--  Core bootstrap – keep this file tiny and fast
-- --------------------------------------------------------------

-- Enable the built‑in Lua loader (pre‑compiles modules on first require)
vim.loader.enable()

-- --------------------------------------------------------------
--  Global Neovim options – “suck‑less” performance tweaks
-- --------------------------------------------------------------
vim.opt.lazyredraw      = true          -- redraw only after commands finish
vim.opt.updatetime      = 200           -- faster CursorHold events
vim.opt.timeoutlen      = 300           -- shorter waiting time for mapped keys
vim.opt.ttimeoutlen    = 50
vim.opt.termguicolors   = true
vim.opt.background      = 'dark'

-- UI trimming
vim.opt.showmode        = false
vim.opt.showcmd         = false
vim.opt.ruler           = false
vim.opt.cmdheight       = 0             -- hide command line when not used (Neovim 0.9+)
vim.opt.laststatus      = 2             -- global status line
vim.opt.signcolumn      = 'yes:1'       -- single column for diagnostics
vim.opt.scrolloff       = 4
vim.opt.sidescrolloff   = 8
vim.opt.foldmethod      = 'expr'
vim.opt.foldexpr        = 'nvim_treesitter#foldexpr()'   -- if you keep treesitter
vim.opt.foldlevelstart  = 99            -- start with all folds open

-- Disable built‑ins we don’t need (we use Oil instead of netrw)
vim.g.loaded_netrw            = 1
vim.g.loaded_netrwPlugin      = 1
vim.g.loaded_zipPlugin        = 1
vim.g.loaded_tarPlugin        = 1
vim.g.loaded_2html_plugin    = 1
vim.g.loaded_getscript        = 1
vim.g.loaded_spellfile_plugin = 1

-- Disable language providers you don’t use (avoid spawning processes)
vim.g.loaded_python_provider  = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider    = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_perl_provider    = 0

-- Diagnostic UI – less virtual‑text, more signs
vim.diagnostic.config{
  virtual_text = false,
  underline    = true,
  signs        = true,
}

-- --------------------------------------------------------------
--  Load the modular configuration pieces
-- --------------------------------------------------------------
require('plugins')        -- lazy‑nvim plugin list
require('settings')      -- UI options, keymaps
require('completion')    -- nvim‑cmp + AI sources
require('lsp')           -- LSP + null‑ls
require('theme')         -- Catppuccin theme
require('telescope_cfg') -- Telescope tuned for fd/rg (+ fzf_native)

-- Optional UI extras (still lazy‑loaded)
require('lualine').setup{}
require('gitsigns').setup{}
