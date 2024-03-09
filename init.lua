local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)


-- Setup nvim-tree
-- optionally enable 24-bit colour
vim.opt.termguicolors = true



vim.api.nvim_exec('language en_US', true)
vim.g.mapleader = ' '
vim.keymap.set('n', '<leader>m', vim.cmd.Ex)


-- vim.opt.guicursor = ''

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('UserProfile') .. '\\.vim\\undodir'
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true


vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'


vim.opt.updatetime = 50

vim.opt.colorcolumn = '80'



require('lazy').setup('dnlx.plugins')

require('dnlx.remap')
require('dnlx.config')
