-- lua/lsp.lua -------------------------------------------------------------
-- 1️⃣  Install / ensure language servers via Mason
-- 2️⃣  Configure each LSP server (including the new ts_ls)
-- 3️⃣  Load the none‑ls (null‑ls fork) configuration

local lspconfig = require('lspconfig')
local mason     = require('mason')
local mason_lsp = require('mason-lspconfig')

--------------------------------------------------------------------
-- 1️⃣  Mason – make sure the servers we want are installed
--------------------------------------------------------------------
mason.setup()

mason_lsp.setup{
  ensure_installed = {
    'pyright',        -- Python
    'ts_ls',          -- TypeScript / JavaScript (replaces tsserver)
    'gopls',          -- Go
    'rust_analyzer',  -- Rust
    'bashls',         -- Bash
    'yamlls',         -- YAML
    -- add more if you need them
  },
  automatic_installation = true,
}

--------------------------------------------------------------------
-- 2️⃣  Shared on_attach & capabilities
--------------------------------------------------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion = {
  completionItem = {
    snippetSupport = true,
    resolveSupport = {
      properties = { 'documentation', 'detail', 'additionalTextEdits' },
    },
  },
}
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K',  '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)

  -- Format on save (if the server provides it)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = true }),
      buffer = bufnr,
      callback = function() vim.lsp.buf.format() end,
    })
  end
end

--------------------------------------------------------------------
-- 3️⃣  Setup each server
--------------------------------------------------------------------
local servers = {
  pyright = {},
  ts_ls   = {},   -- ← new name
  gopls   = {},
  rust_analyzer = {},
  bashls  = {},
  yamlls  = {},
}

for name, cfg in pairs(servers) do
  lspconfig[name].setup(vim.tbl_extend('force', {
    on_attach    = on_attach,
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
  }, cfg))
end

--------------------------------------------------------------------
-- 4️⃣  Load none‑ls (null‑ls fork) configuration
--------------------------------------------------------------------
require('none_ls_cfg')
