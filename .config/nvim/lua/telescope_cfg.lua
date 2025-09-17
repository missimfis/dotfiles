-- lua/telescope_cfg.lua ---------------------------------------------------
local telescope = require('telescope')
local actions   = require('telescope.actions')

-- Helper: pick the correct fd executable (Ubuntu/Debian uses `fdfind`)
local function get_fd_cmd()
  if vim.fn.executable('fd') == 1 then return 'fd' end
  if vim.fn.executable('fdfind') == 1 then return 'fdfind' end
  return 'fd'   -- fallback – will error if missing, which is fine
end

telescope.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
    },
    prompt_prefix      = '🔍 ',
    selection_caret    = '➤ ',
    entry_prefix       = '  ',
    initial_mode       = 'insert',
    selection_strategy = 'reset',
    sorting_strategy   = 'ascending',
    layout_strategy    = 'horizontal',
    layout_config = {
      horizontal = { preview_width = 0.55, results_width = 0.8 },
      vertical   = { mirror = false },
    },
    file_sorter        = require('telescope.sorters').get_fuzzy_file,
    generic_sorter     = require('telescope.sorters').get_generic_fuzzy_sorter,
    path_display       = { 'truncate' },
    winblend           = 0,
    border             = {},
    borderchars = { '─','│','─','│','╭','╮','╯','╰' },
    color_devicons     = true,
    use_less           = true,
    set_env = { ['COLORTERM'] = 'truecolor' },

    mappings = {
      i = {
        ['<esc>'] = actions.close,
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
      n = {
        ['q'] = actions.close,
      },
    },
  },

  pickers = {
    find_files = {
      find_command = { get_fd_cmd(), '--type', 'f', '--strip-cwd-prefix', '--max-results', '5000' },
      hidden = true,
      follow = true,
    },

    live_grep = {
      additional_args = function(_) return { '--hidden', '--smart-case' } end,
    },

    buffers = {
      sort_lastused = true,
      theme = 'dropdown',
      previewer = false,
    },

    oldfiles = {
      cwd_only = true,
    },
  },

  extensions = {
    -- fzf_native will be loaded on demand (see plugins.lua)
    -- file_browser will be loaded on demand as well
  },
}

-- -----------------------------------------------------------------
-- Load optional extensions **only if they are installed**
-- -----------------------------------------------------------------
pcall(function() telescope.load_extension('fzf') end)          -- fzf‑native matcher
pcall(function() telescope.load_extension('file_browser') end) -- file‑browser UI

-- You can now call it with:
--   :Telescope file_browser
--   :Telescope file_browser path=%:p:h
