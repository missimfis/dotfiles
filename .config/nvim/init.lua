-- init.lua - Minimal Fast Neovim Config

vim.loader.enable()

-- Leader keys MUST be set before loading plugins
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Core options
local opt = vim.opt
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.relativenumber = true
opt.number = true
opt.showmode = false
opt.showcmd = false
opt.ruler = false
opt.cmdheight = 1
opt.laststatus = 3
opt.signcolumn = 'yes:1'
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.cursorline = true
opt.termguicolors = true
opt.timeoutlen = 300
opt.updatetime = 200
opt.redrawtime = 1500
opt.hidden = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 100000
opt.splitbelow = true
opt.splitright = true
opt.completeopt = { 'menu', 'menuone', 'noselect' }
opt.pumheight = 10
opt.shortmess:append('cI')
opt.fillchars = { eob = ' ' }
opt.spelllang = 'en'
opt.iskeyword:append('-')
opt.formatoptions:append('j')
opt.whichwrap:append('<>[]hl')
opt.startofline = false
opt.sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize'
opt.viewoptions = 'buffers,curdir,folds,help,tabpages,winsize'

vim.g.markdown_fenced_languages = { 'ts=typescript', 'js=javascript', 'py=python', 'bash=sh' }

require('keymaps')
require('plugin')
