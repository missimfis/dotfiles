local opt = vim.opt
opt.number = true
opt.relativenumber = true

opt.autoindent = true

opt.ttyfast = true

opt.undofile = true

opt.splitbelow = true
opt.splitright = true


opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 0 -- set to 0 to default to tabstop value

vim.cmd('syntax on')          -- Enable syntax highlighting
opt.showmatch = true      -- Highlight matching parentheses, brackets, or braces when the cursor is on one of them

opt.ignorecase = true     -- Make search operations case insensitive
opt.hlsearch = true       -- Highlight all occurrences of the search pattern
opt.incsearch = true      -- Update search results incrementally as you type

-- opt.termguicolors = true
opt.background = "dark" -- colorschemes can be light or dark
opt.signcolumn = "yes" -- show sign column so that text doesnt shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position 

opt.mouse = 'v'                -- Enable pasting the copied text with mouse' middle-click
opt.clipboard = 'unnamedplus'  -- Use the system's clipboard


-- turn off swapfile
opt.swapfile = false
