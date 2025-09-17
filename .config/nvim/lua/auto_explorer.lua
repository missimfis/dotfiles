-- ──────────────────────────────────────────────────────────────
--  Auto‑open netrw on start‑up when no file is given
--  and make netrw display hidden files (dot‑files) by default
-- ──────────────────────────────────────────────────────────────

-- 1️⃣ NetRW options – hide‑dot‑files disabled, nicer layout
vim.g.netrw_banner      = 0          -- no banner
vim.g.netrw_liststyle   = 3          -- tree‑style view
vim.g.netrw_browse_split = 4         -- open files in prior window
vim.g.netrw_altv        = 1          -- split to the right
vim.g.netrw_winsize     = 30         -- width of the explorer pane (%)
vim.g.netrw_hide        = 0          -- **show dot‑files** (0 = don’t hide)

-- 2️⃣ Autocommand that runs *once* on VimEnter
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = function()
    -- If Neovim was started **without any file arguments**
    if vim.fn.argc() == 0 then
      -- Open netrw in the current window
      vim.cmd('Explore')
    end
  end,
})
