vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Paste but keep copied value.
vim.keymap.set("x", "<leader>p", [["_dP]])


-- for multi line I at the beginning:
vim.keymap.set("i", "<C-c>", "<Esc>")

-- get rid of the damn undo
vim.keymap.set("i", "<C-u>", "<c-g>u<c-u>")
vim.keymap.set("i", "<C-w>", "<c-g>w<c-w>")



