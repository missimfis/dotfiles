-- --------------------------------------------------------------
--  Catppuccin – high‑contrast dark theme
-- --------------------------------------------------------------
vim.cmd [[colorscheme catppuccin]]

require('catppuccin').setup{
  flavour = 'macchiato',          -- deep, high‑contrast palette
  background = { light = 'latte', dark = 'macchiato' },
  transparent_background = false,
  term_colors = true,
  integrations = {
    telescope = true,
    cmp = true,
    gitsigns = true,
    lsp_trouble = true,
    which_key = true,
  },
}
