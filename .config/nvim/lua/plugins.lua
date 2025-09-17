-- lua/plugins.lua ---------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  ----------------------------------------------------------------
  -- Core LSP / Completion
  ----------------------------------------------------------------
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },

  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },

  ----------------------------------------------------------------
  -- AI / Copilot (cloud) – free tier
  ----------------------------------------------------------------
  { 'github/copilot.vim', lazy = true, event = 'InsertEnter' },

  ----------------------------------------------------------------
  -- AI / Local LLM via Ollama
  ----------------------------------------------------------------
  { 'olimorris/codecompanion.nvim',
    lazy = true,
    cmd  = { 'CodeCompanionChat', 'CodeCompanionAsk' },
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
    opts = { backend = 'ollama', model = 'codellama' },
  },

  ----------------------------------------------------------------
  -- Null‑ls (formatters / linters)
  ----------------------------------------------------------------
 { 'nvimtools/none-ls.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  ----------------------------------------------------------------
  -- File explorer (Oil)
  ----------------------------------------------------------------
  { 'stevearc/oil.nvim', opts = {} },

  ----------------------------------------------------------------
  -- Telescope + optional extensions
  ----------------------------------------------------------------
  { 'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
  },

  -- fzf‑native matcher (compiled, optional – lazy‑loaded)
  { 'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    lazy = true,
  },

  -- **File‑browser extension** (this was missing before)
  { 'nvim-telescope/telescope-file-browser.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    lazy = true,
  },

  ----------------------------------------------------------------
  -- Theme – Catppuccin (high‑contrast)
  ----------------------------------------------------------------
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },

  ----------------------------------------------------------------
  -- Optional UI polish
  ----------------------------------------------------------------
  { 'nvim-lualine/lualine.nvim', lazy = true, event = 'VimEnter' },
  { 'lewis6991/gitsigns.nvim',   lazy = true, event = 'BufReadPre' },

  ----------------------------------------------------------------
  -- Treesitter (syntax highlighting) – lazy‑load on filetype
  ----------------------------------------------------------------
  { 'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'BufReadPost',
  },

}, {})
