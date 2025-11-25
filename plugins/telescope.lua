return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },

    config = function()
        -- Telescope Bindings
        local builtin = require('telescope.builtin')

        -- Get the Neovim config directory in a cross-platform way
        local config_dir = vim.fn.stdpath('config')
        -- Append the relative path using the proper path separator
        local nvim_lua_dir = config_dir .. ''

        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>en', function()
            builtin.find_files({
                cwd = nvim_lua_dir,
                prompt_title = "Neovim Config Files",
            })
        end, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        -- vim.keymap.set('n', '<leader>fg', function()
        --     builtin.grep_string({ search = vim.fn.input("Grep > ") })
        -- end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}
