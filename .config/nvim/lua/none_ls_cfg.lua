--=====================================================================
--  none‑ls (null‑ls fork) configuration
--=====================================================================

local none_ls = require('null-ls')
local h       = none_ls.helpers   -- kept for possible future helpers

-- Helper: only create a source if the executable exists on $PATH
local function maybe(src_factory, exe_name)
  if vim.fn.executable(exe_name) == 1 then
    return src_factory()
  else
    vim.notify(
      string.format('[none‑ls] Skipping %s – not installed', exe_name),
      vim.log.levels.WARN
    )
    return nil
  end
end

none_ls.setup{
  debounce = 150,
  sources = vim.tbl_filter(
    function(s) return s ~= nil end,
    {
      -- Python
      maybe(function() return none_ls.builtins.formatting.black end,      'black'),
      maybe(function() return none_ls.builtins.diagnostics.flake8 end,   'flake8'),

      -- JavaScript / TypeScript / JSON
      maybe(function() return none_ls.builtins.formatting.prettier end,   'prettier'),   -- also formats JSON
      maybe(function() return none_ls.builtins.diagnostics.eslint end,    'eslint'),

      -- Go
      maybe(function() return none_ls.builtins.formatting.gofmt end,     'gofmt'),
      maybe(function() return none_ls.builtins.diagnostics.golangci_lint end, 'golangci-lint'),

      -- Rust
      maybe(function() return none_ls.builtins.formatting.rustfmt end,   'rustfmt'),

      -- Bash / Shell
      maybe(function() return none_ls.builtins.formatting.shfmt end,     'shfmt'),
      maybe(function() return none_ls.builtins.diagnostics.shellcheck end, 'shellcheck'),

      -- JSON fallback (if prettier isn’t present)
      maybe(function() return none_ls.builtins.formatting.fixjson end,    'fixjson'),

      -- YAML
      maybe(function() return none_ls.builtins.diagnostics.yamllint end, 'yamllint'),

      -- NOTE: **eslint‑lsp** (the language‑server) has been removed.
      -- If you really want it, install `vscode-eslint-language-server`
      -- via npm and add:
      --   maybe(function() return none_ls.builtins.diagnostics.eslint_lsp end, 'eslint-lsp')
    }
  ),

on_attach = function(client, bufnr)
  if client.supports_method('textDocument/formatting') then
    local fmt_grp = vim.api.nvim_create_augroup('LspFormatting', { clear = true })
    vim.api.nvim_clear_autocmds({ group = fmt_grp, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group   = fmt_grp,
      buffer  = bufnr,
      callback = function() vim.lsp.buf.format({ async = false }) end,
    })
  end
end,
}
