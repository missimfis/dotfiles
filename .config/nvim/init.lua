-- init.lua - Minimal Fast Neovim Config

vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Core options
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.signcolumn = 'yes:1'
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 200
vim.opt.updatetime = 100
vim.opt.redrawtime = 1500

-- Disable heavy features
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_getscript = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

require('keymaps')
require('plugin')
