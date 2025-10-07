return {
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'L3MON4D3/LuaSnip',
            'hrsh7th/cmp-nvim-lsp',
            'saadparwaiz1/cmp_luasnip', 
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            
            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                }),
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-f>'] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<C-b>'] = cmp.mapping(function(fallback)
                        if luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
            })
        end
    },

    -- Mason for installing LSP servers
    {
        'williamboman/mason.nvim',
        lazy = false,
        config = true,
    },
    
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {'williamboman/mason.nvim'},
        lazy = false,
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'pyright',
                    'clangd',
                    'bashls',
                    'lua_ls',
                },
            })
        end
    },

    -- LSP Configuration
    {
        'neovim/nvim-lspconfig',
        event = {'BufReadPre', 'BufNewFile'},
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            -- Get default capabilities from nvim-cmp
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            
            -- Set up keymaps when LSP attaches to a buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf, silent = true }
                    
                    -- Keybindings
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({'n', 'x'}, '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
                end,
            })
            
            -- Configure LSP servers using the new vim.lsp.config API
            vim.lsp.config('pyright', {
                cmd = {'pyright-langserver', '--stdio'},
                root_markers = {'pyproject.toml', 'setup.py', 'requirements.txt', 'pyrightconfig.json'},
                capabilities = capabilities,
            })
            
            vim.lsp.config('clangd', {
                cmd = {'clangd'},
                root_markers = {'compile_commands.json', 'compile_flags.txt', '.clangd', '.git'},
                capabilities = capabilities,
            })
            
            vim.lsp.config('bashls', {
                cmd = {'bash-language-server', 'start'},
                root_markers = {'.git'},
                capabilities = capabilities,
            })
            
            vim.lsp.config('lua_ls', {
                cmd = {'lua-language-server'},
                root_markers = {'.luarc.json', '.luarc.jsonc', '.luacheckrc' },
                capabilities = capabilities,
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            globals = {'vim'},
                        },
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME
                            }
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
            
            -- Enable all configured LSP servers
            vim.lsp.enable({'pyright', 'clangd', 'bashls', 'lua_ls'})
        end,
    }
}
