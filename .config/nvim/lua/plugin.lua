-- plugin.lua - Minimal Lazy Config

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--single-branch', 'https://github.com/folke/lazy.nvim.git', lazypath })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Colorscheme
  { 'shaunsingh/nord.nvim', priority = 1000 },

  -- Fuzzy finder (uses system fzf)
  { 'ibhagwan/fzf-lua', dependencies = 'nvim-web-devicons' },

  -- LSP
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'stevearc/conform.nvim' },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'lua', 'vim', 'vimdoc', 'bash', 'python', 'javascript', 'typescript', 'html', 'css', 'json', 'yaml', 'markdown' },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Essentials
  { 'tpope/vim-surround' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-unimpaired' },
  { 'tpope/vim-repeat' },
  { 'tpope/vim-eunuch' },
  { 'tpope/vim-sleuth' },
  { 'tpope/vim-projectionist' },
  { 'AndrewRadev/switch.vim' },
  { 'AndrewRadev/sideways.vim' },

  -- Git
  { 'lewis6991/gitsigns.nvim', dependencies = 'nvim-lua/plenary.nvim' },

  -- Completion
  { 'hrsh7th/nvim-cmp', dependencies = 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },

  -- Motion
  { 'ggandor/leap.nvim', dependencies = 'tpope/vim-repeat' },

  -- UI
  { 'nvim-lualine/lualine.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },
})

-- LSP Config
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  underline = true,
  signs = true,
  update_in_insert = false,
})

vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    if client.supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(bufnr, true)
    end
  end,
})

-- Conform
require('conform').setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_format' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    json = { 'prettier' },
    css = { 'prettier' },
    html = { 'prettier' },
    markdown = { 'prettier' },
    go = { 'gofmt' },
    rust = { 'rustfmt' },
  },
})

-- Treesitter context - disable for performance
vim.g.treesitter_context_max_lines = 0

-- Lualine
require('lualine').setup({
  options = {
    theme = 'nord',
    component_separators = '',
    section_separators = '',
    globalstatus = true,
  },
})

-- Mason
require('mason').setup({ log_level = vim.log.levels.WARN })
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'pyright', 'ruff', 'ts_ls', 'gopls', 'rust_analyzer' },
  automatic_installation = true,
})

-- Gitsigns
require('gitsigns').setup({ signcolumn = false, numhl = false })

-- Leap
require('leap').add_default_mappings()
