local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()


require'py_lsp'.setup {
  -- This is optional, but allows to create virtual envs from nvim
  host_python = "C:\\rgc-tools\\Environment\\python\\39-64",
  default_venv_name = ".venv" -- For local venv
}
