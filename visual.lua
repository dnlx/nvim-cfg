-- line number on with relative linenumbers
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.signcolumn = "yes:1"    -- Minimal sign column
vim.opt.cursorline = true       -- Highlight current line
vim.opt.showmode = false        -- Don't show mode in command line
vim.opt.ruler = false           -- Hide ruler
vim.opt.laststatus = 3          -- Global statusline
vim.opt.cmdheight = 1           -- Command line height
vim.opt.scrolloff = 10          -- Keep cursor centered vertically
vim.opt.termguicolors = true    -- True color support
 -- vim.opt.showtabline = 0         -- Hide tabline
vim.opt.colorcolumn = '80'
vim.opt.fillchars = {           -- Minimal separators
  vert = "│",
  fold = " ",
  eob = " ",
  diff = "─",
  msgsep = "‾",
  foldopen = "▾",
  foldsep = "│",
  foldclose = "▸",
}
-- require('lualine').setup {
--   options = {
--     icons_enabled = false,
--     component_separators = { left = '│', right = '│'},
--     section_separators = { left = '', right = ''},
--     globalstatus = true,
--     theme = 'tokyonight'
--   },
--   sections = {
--     lualine_a = {'mode'},
--     lualine_b = {},
--     lualine_c = {'filename'},
--     lualine_x = {'filetype'},
--     lualine_y = {'progress'},
--     lualine_z = {'location'}
--   }
-- }
