-- --------------------------------------------------------------
--  nvim‑cmp configuration – combines LSP, buffer, path, Copilot,
--  and local Ollama (CodeCompanion) sources.
-- --------------------------------------------------------------
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      -- You can replace vsnip with luasnip or any other snippet engine
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>']      = cmp.mapping.confirm({ select = true }),
    ['<Tab>']     = cmp.mapping.select_next_item(),
    ['<S-Tab>']   = cmp.mapping.select_prev_item(),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },          -- LSP completions
    { name = 'copilot' },           -- Cloud Copilot (if enabled)
    { name = 'codecompanion' },    -- Local Ollama completions
    { name = 'buffer' },           -- Words in current buffer
    { name = 'path' },              -- Filesystem paths
  })
})

-- Cmd‑line completion (optional)
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
})
