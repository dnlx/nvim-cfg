-- -- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)
vim.loader.enable()


-- General options
-- vim.api.nvim_exec({'language en_US'}, {true})
vim.cmd("language en_US.UTF-8")
vim.g.mapleader = ' '
-- vim.keymap.set('n', '<leader>m', vim.cmd.Ex)
vim.keymap.set('n', '<leader>m', "<CMD>Oil<CR>")
vim.keymap.set('n', '<leader>n', "<CMD>Oil --float<CR>")
-- vim.keymap.set('n', '<leader>m', "<CMD>lua MiniFiles.open()<CR>")


--- Tabs and shifting of lines are 4 white spaces wide and get expanded
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- And also auto tab on newline
vim.opt.smartindent = true

-- And please do not wrap lines..
vim.opt.wrap = false

-- some tech stuff
vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv('UserProfile') .. '\\.vim\\undodir'
local homedir = vim.loop.os_homedir()
vim.opt.undofile = true

-- how my search works
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.updatetime = 50


-- stuff
vim.api.nvim_create_autocmd({"BufWritePre"}, {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

require('lazy').setup('dnlx.plugins')
-- Why do I need to set up lualine here?

require('dnlx.remap')
require('dnlx.visual')
