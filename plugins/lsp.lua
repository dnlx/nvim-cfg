
return {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
        -- LSP Management
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-nvim-lsp',

        -- Optional but recommended for performance and UX
        'j-hui/fidget.nvim',
    },
    config = function()
        -- ───────────────────────────────────────────────
        -- Mason + Fidget setup
        -- ───────────────────────────────────────────────
        require('fidget').setup({})
        require('mason').setup({
            ui = { border = 'rounded' },
        })

        -- LSP capabilities (for nvim-cmp)
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = { 'documentation', 'detail', 'additionalTextEdits' },
        }

        -- ───────────────────────────────────────────────
        -- Mason-LSPConfig setup
        -- ───────────────────────────────────────────────
        require('mason-lspconfig').setup({
            ensure_installed = {
                'lua_ls',
                'pyright',
                'rust_analyzer',
            },
            handlers = {
                -- Default handler for all servers
                function(server_name)
                    require('lspconfig')[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                -- Lua LSP
                ["lua_ls"] = function()
                    require('lspconfig').lua_ls.setup({
                        capabilities = capabilities,
                        on_init = function(client)
                            if client.workspace_folders then
                                local path = client.workspace_folders[1].name
                                if
                                    path ~= vim.fn.stdpath('config')
                                    and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
                                then
                                    return
                                end
                            end
                            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                                runtime = {
                                    version = 'LuaJIT',
                                    path = { 'lua/?.lua', 'lua/?/init.lua' },
                                },
                                workspace = {
                                    checkThirdParty = false,
                                    library = { vim.env.VIMRUNTIME },
                                },
                            })
                        end,
                        settings = {
                            Lua = { globals = { 'vim' } },
                        },
                    })
                end,

                -- Python (Pyright)
                ["pyright"] = function()
                    require('lspconfig').pyright.setup({
                        capabilities = capabilities,
                        settings = {
                            python = {
                                analysis = {
                                    autoSearchPaths = true,
                                    diagnosticMode = "workspace",
                                    useLibraryCodeForTypes = true,
                                    typeCheckingMode = "basic",
                                },
                            },
                        },
                        flags = { debounce_text_changes = 150 },
                    })
                end,

                -- Rust
                ["rust_analyzer"] = function()
                    require('lspconfig').rust_analyzer.setup({
                        capabilities = capabilities,
                        settings = {
                            ["rust-analyzer"] = {
                                cargo = { allFeatures = true },
                                checkOnSave = { command = "clippy" },
                            },
                        },
                    })
                end,
            },
        })

        -- ───────────────────────────────────────────────
        -- LSP Keybindings
        -- ───────────────────────────────────────────────
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references)
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

        -- ───────────────────────────────────────────────
        -- Diagnostics Configuration
        -- ───────────────────────────────────────────────
        vim.diagnostic.config({
            virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
            update_in_insert = false,
            severity_sort = true,
            float = { header = '', prefix = '' },
        })

        -- ───────────────────────────────────────────────
        -- nvim-cmp Setup
        -- ───────────────────────────────────────────────
        local cmp = require('cmp')
        cmp.setup({
            mapping = cmp.mapping.preset.insert({
                ['<C-k>'] = cmp.mapping.select_prev_item(),
                ['<C-j>'] = cmp.mapping.select_next_item(),
                ['<C-z>'] = cmp.mapping.confirm({ select = true }),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-Space>'] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({ { name = 'nvim_lsp' } }),
            formatting = {
                format = function(entry, vim_item)
                    if vim_item.abbr then
                        vim_item.abbr = vim_item.abbr:gsub("\r", "")
                    end
                    return vim_item
                end
            },
            experimental = { ghost_text = false },
            performance = { max_view_entries = 20, debounce = 100, throttle = 50 },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            enabled = function()
                local context = require('cmp.config.context')
                if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then return false end
                return not context.in_treesitter_capture('comment')
                    and not context.in_syntax_group('Comment')
            end,
        })

        -- ───────────────────────────────────────────────
        -- Remove carriage returns (\r) from inserted text
        -- Works for multi-line completions on Windows
        -- ───────────────────────────────────────────────
        cmp.event:on('confirm_done', function(event)
            local bufnr = vim.api.nvim_get_current_buf()
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
            for i, line in ipairs(lines) do
                lines[i] = line:gsub("\r", "")
            end
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
        end)
    end,
}
