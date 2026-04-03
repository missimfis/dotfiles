-- plugin.lua - Minimal Fast Lazy Config

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--single-branch', 'https://github.com/folke/lazy.nvim.git', lazypath })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Colorscheme (load first)
  { 'shaunsingh/nord.nvim', priority = 1000, lazy = false },

  -- File explorer
  { 'stevearc/oil.nvim', cmd = 'Oil', config = function() require('oil').setup({ default_file_explorer = true }) end },

  -- Fuzzy finder
  { 'ibhagwan/fzf-lua', cmd = { 'FzfLua' }, dependencies = 'nvim-web-devicons',
    config = function() require('fzf-lua').setup({}) end,
  },

  -- LSP
  { 'neovim/nvim-lspconfig', event = { 'BufReadPre', 'BufNewFile' } },
  { 'williamboman/mason.nvim', cmd = 'Mason' },
  { 'williamboman/mason-lspconfig.nvim', dependencies = { 'mason.nvim', 'nvim-lspconfig' } },
  { 'stevearc/conform.nvim', event = 'BufWritePre' },

  -- Treesitter (v1.0+ - highlighting/indent automatic via Neovim)
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()
      local needed = { 'lua', 'bash', 'python', 'javascript', 'typescript', 'html', 'css', 'json', 'yaml', 'markdown', 'vim', 'vimdoc', 'diff', 'gitcommit', 'git_rebase' }
      local installed = require('nvim-treesitter.config').get_installed('parsers')
      local to_install = vim.tbl_filter(function(l) return not vim.list_contains(installed, l) end, needed)
      if #to_install > 0 then
        require('nvim-treesitter.install').install(to_install, { summary = true })
      end
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterStart', { clear = true }),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },

  -- Essentials (vim-surround needs to load immediately for s/S mappings)
  { 'tpope/vim-surround', event = 'VeryLazy' },
  { 'tpope/vim-commentary', event = 'VeryLazy' },
  { 'tpope/vim-unimpaired', event = 'VeryLazy' },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  { 'tpope/vim-eunuch', cmd = { 'Delete', 'Move', 'Chmod', 'Mkdir', 'Rename' } },
  { 'tpope/vim-sleuth', event = { 'BufReadPost', 'BufNewFile' } },
  { 'tpope/vim-projectionist', event = 'VeryLazy' },
  { 'AndrewRadev/switch.vim', cmd = 'Switch' },
  { 'AndrewRadev/sideways.vim', event = 'VeryLazy' },

  -- Git
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('gitsigns').setup({ signcolumn = false, numhl = true })
    end,
  },

  -- Completion
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        performance = {
          debounce = 60,
          throttle = 30,
          fetching_timeout = 500,
        },
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
      })
    end,
  },

  -- Motion (load on keys to avoid startup cost)
  { 'ggandor/leap.nvim', keys = { 'gs', 'gS' } },

  -- UI
  {
    'nvim-lualine/lualine.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons',
    event = 'VeryLazy',
    config = function()
      require('lualine').setup({
        options = {
          theme = 'nord',
          component_separators = '',
          section_separators = '',
          globalstatus = true,
        },
      })
    end,
  },
}, {
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip', 'matchit', 'netrwPlugin', 'tarPlugin', 'tohtml',
        'tutor', 'zipPlugin', 'rplugin',
      },
    },
  },
})

-- LSP Config
vim.diagnostic.config({
  virtual_text = { prefix = '●' },
  underline = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Mason
require('mason').setup({ log_level = vim.log.levels.WARN })
require('mason-lspconfig').setup({
  ensure_installed = { 'lua_ls', 'pyright', 'ruff', 'ts_ls', 'gopls', 'rust_analyzer' },
  automatic_installation = true,
})

-- LSP capabilities (set globally so all servers pick it up)
vim.lsp.config('*', {
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    if client.supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
  format_on_save = {
    timeout_ms = 1000,
    lsp_format = 'fallback',
  },
})
