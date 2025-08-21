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

        -- Optional but recommended for performance
        'j-hui/fidget.nvim', -- LSP status updates
    },
    config = function()
        -- Set up Mason first
        require('fidget').setup({})
        require('mason').setup({
            ui = { border = 'rounded', },
        })

        -- Configure LSP completion
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- Performance optimizations
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        capabilities.textDocument.completion.completionItem.preselectSupport = true
        capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
        capabilities.textDocument.completion.completionItem.resolveSupport = {
            properties = {
                'documentation',
                'detail',
                'additionalTextEdits',
            }
        }

        require('mason-lspconfig').setup({
            ensure_installed = {
                'lua_ls',
                'pyright',
            },
            handlers = {
                function (server_name)
                    require('lspconfig')[server_name].setup({})
                end,
                -- Example server with optimized settings
                ["lua_ls"] = function()
                    require('lspconfig').lua_ls.setup({
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
                                -- Tell the language server which version of Lua you're using (most
                                -- likely LuaJIT in the case of Neovim)
                                version = 'LuaJIT',
                                -- Tell the language server how to find Lua modules same way as Neovim
                                -- (see `:h lua-module-load`)
                                path = {
                                  'lua/?.lua',
                                  'lua/?/init.lua',
                                },
                              },
                              -- Make the server aware of Neovim runtime files
                              workspace = {
                                checkThirdParty = false,
                                library = {
                                  vim.env.VIMRUNTIME
                                  -- Depending on the usage, you might want to add additional paths
                                  -- here.
                                  -- '${3rd}/luv/library'
                                  -- '${3rd}/busted/library'
                                }
                                -- Or pull in all of 'runtimepath'.
                                -- NOTE: this is a lot slower and will cause issues when working on
                                -- your own configuration.
                                -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                                -- library = {
                                --   vim.api.nvim_get_runtime_file('', true),
                                -- }
                              }
                            })
                          end,
                          settings = {
                            Lua = {
                            globals = {'vim'}
                        }
                        }
                    })
                end,

                -- Set up other servers
                ["pyright"] = function()
                    require('lspconfig').pyright.setup({
                      capabilities = capabilities,
                      settings = {
                        python = {
                          analysis = {
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "basic", -- Use 'off' for max performance
                          }
                        }
                      },
                      flags = {
                        debounce_text_changes = 150,
                      }
                    })
                end,
            }
        })

        -- LSP keybindings
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references)

        -- Diagnostics navigation
        vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

        -- Diagnostics config (for performance)
        vim.diagnostic.config({
          virtual_text = {
            -- prefix = '●',
            severity = {
              min = vim.diagnostic.severity.WARN
            }
          },
          update_in_insert = false, -- Update diagnostics after leaving insert mode
          severity_sort = true,
          float = {
            -- border = 'rounded',
            -- source = 'always',
            header = '',
            prefix = '',
          },
        })


        local cmp = require('cmp')
        cmp.setup({
             mapping = cmp.mapping.preset.insert({
                  ['<C-k>'] = cmp.mapping.select_prev_item(),
                  ['<C-j>'] = cmp.mapping.select_next_item(),
                  -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  ['<C-z>'] = cmp.mapping.confirm({ select = true }),
                  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                  ["<C-Space>"] = cmp.mapping.complete(),
              }),
              sources = cmp.config.sources({
              { name = 'nvim_lsp' },
            }),
            -- Performance settings
            performance = {
              max_view_entries = 20,
              debounce = 100,
              throttle = 50,
            },
            -- Simple window styling
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            -- Prevent completion in comments
            enabled = function()
              local context = require('cmp.config.context')
              if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then return false end
              return not context.in_treesitter_capture('comment')
                and not context.in_syntax_group('Comment')
            end
          })
        end

}
