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
    event = { 'BufReadPre', 'BufNewFile' },
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup({ highlight = { enable = true }, indent = { enable = true } })
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
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory' },
  },
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = vim.opt.sessionoptions:get() },
  },
  {
    'folke/todo-comments.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('todo-comments').setup({
        keywords = {
          FIX = { icon = '🔥', color = 'error', alt = { 'FIXME', 'BUG', 'HACK' } },
          TODO = { icon = '💭', color = 'info' },
          WARN = { icon = '⚠️', color = 'warning', alt = { 'WARNING' } },
          PERF = { icon = '⚡', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
          NOTE = { icon = '📝', color = 'hint', alt = { 'INFO' } },
          TEST = { icon = '🧪', color = 'test', alt = { 'TESTING', 'PASS' } },
        },
        highlight = { keyword = 'wide' },
      })
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
      local luasnip = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            end
          end, { 'i', 's' }),
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

  -- Database (vim-dadbod)
  { 'tpope/vim-dadbod', cmd = { 'DB', 'DBUI' } },
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = { 'tpope/vim-dadbod' },
    cmd = { 'DBUI', 'DBUIToggle' },
    config = function()
      vim.g.db_ui_save_location = vim.fn.stdpath('data') .. '/db_ui'
    end,
  },

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

  -- Terminal
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup({
        size = 15,
        open_mapping = '<C-\\>',
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = 'float',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 0,
          highlights = { border = 'Normal', background = 'Normal' },
        },
      })
    end,
  },

  -- Debugging
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },

  -- Which-key (keybinding hints)
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({
        win = {
          border = 'single',
        },
      })
    end,
  },

  -- AI: Local completions via Ollama (llama-cmp) - manual trigger only
  {
    'maxpaulus43/llama-cmp.nvim',
    opts = {
      model = 'qwen2.5-coder:3b',
      endpoint = 'http://localhost:11434',
      auto_trigger = false,
      debounce_ms = 500,
      fim = {
        prefix = '<|fim_prefix|>',
        middle = '<|fimMiddle|>',
        suffix = '<|fim_suffix|>',
      },
    },
  },

  -- AI: Local chat/buffer assist via Ollama (nvim.ai)
  {
    'magicalne/nvim.ai',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('ai').setup({
        provider = 'ollama',
        ollama = {
          model = 'qwen2.5-coder:3b',
          endpoint = 'http://localhost:11434',
        },
        keymaps = {
          toggle = '<leader>ai',
          insert = '<leader>aii',
        },
      })
    end,
  },

  -- plenary (dependency for nvim.ai)
  { 'nvim-lua/plenary.nvim', lazy = true },
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

-- Disable syntax in very large files for performance
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('LargeFile', { clear = true }),
  callback = function()
    local ok, stats = pcall(vim.filetype.get_bufstats, vim.api.nvim_get_current_buf())
    if ok and stats and stats.size > 500000 then
      vim.b.minicues_enabled = false
      vim.opt_local.syntax = 'OFF'
      vim.opt_local.foldmethod = 'manual'
    end
  end,
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
-- Use pcall for compatibility across Neovim 0.10 and 0.11+
local lsp_config_ok, _ = pcall(function()
  vim.lsp.config('*', {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = function(client, bufnr)
      if client.supports_method('textDocument/inlayHint') then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end,
  })
end)
if not lsp_config_ok then
  -- Neovim 0.10 fallback: set capabilities per-server via handlers
  local default_capabilities = require('cmp_nvim_lsp').default_capabilities()
  local default_on_attach = function(client, bufnr)
    if client.supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end
  vim.lsp.set_server_config({
    capabilities = default_capabilities,
    on_attach = default_on_attach,
  })
end

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
