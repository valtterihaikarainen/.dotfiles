vim.cmd('source ~/.dotfiles/common/.config/vim/vimrc')

vim.opt.termguicolors = false

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2D2A2E" }) 
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#75715E", bg = "#2D2A2E" })
vim.api.nvim_set_hl(0, "DiagnosticFloating", { link = "NormalFloat" })

vim.opt.winborder = "rounded"

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    local line = vim.fn.line('.') - 1
    local col = vim.fn.col('.')
    local diagnostics = vim.diagnostic.get(0, { lnum = line })
    
    if #diagnostics > 0 then
      local diag = diagnostics[1]
      local message = string.format('[%s] %s', diag.source or 'LSP', diag.message)
      vim.api.nvim_echo({{message, 'WarningMsg'}}, false, {})
    end
  end
})

vim.opt.updatetime = 250

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	{ src = "https://github.com/lervag/vimtex" },
	{ src = 'https://github.com/neovim/nvim-lspconfig' },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" }, 
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/tpope/vim-surround" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },  -- LSP completion source
    { src = "https://github.com/hrsh7th/cmp-buffer" },    -- Buffer words
    { src = "https://github.com/hrsh7th/cmp-path" },      -- File paths
    { src = "https://github.com/L3MON4D3/LuaSnip" },      -- Snippet engine (required)
    { src = "https://github.com/saadparwaiz1/cmp_luasnip" }, -- Snippet completions
})

vim.cmd[[colorscheme tokyonight]]

vim.lsp.config.basedpyright = {
	cmd = { 'basedpyright-langserver', '--stdio' },
	filetypes = { 'python' },
	root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
	settings = {
		basedpyright = {
			analysis = {
				-- Type checking mode
				typeCheckingMode = "standard", -- "off", "basic", "standard", "strict", "all"
				
				-- Auto-import completions
				autoImportCompletions = true,
				autoSearchPaths = true,
				
				-- Diagnostics options
				diagnosticMode = "openFilesOnly", -- or "workspace"
				useLibraryCodeForTypes = true,
				
				-- Diagnostic severity overrides
				diagnosticSeverityOverrides = {
					reportUnusedImport = "information",
					reportUnusedVariable = "warning",
					reportDuplicateImport = "warning",
					reportPrivateUsage = "warning",
					reportUntypedFunctionDecorator = "none",
					reportUntypedClassDecorator = "none",
				},
			}
		}
	}
}

require('nvim-treesitter.configs').setup({
  ensure_installed = { "lua", "python", "vim", "vimdoc" }, -- Add languages you use
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
})

vim.lsp.enable('basedpyright')


-- Set up nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    
    completion = {
        autocomplete = { 
            require('cmp.types').cmp.TriggerEvent.TextChanged 
        },
    },
    
    matching = {
        disallow_fuzzy_matching = false,
        disallow_partial_fuzzy_matching = false,
        disallow_partial_matching = false,
        disallow_prefix_unmatching = false,
    },
    
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.recently_used,  -- Recently used items first
            cmp.config.compare.locality,        -- Items closer in file
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
    
    window = {
        completion = {
            border = 'rounded',
            winhighlight = 'Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None',
            max_width = 60,
            max_height = 20,
            scrollbar = true,
        },
        documentation = {
            border = 'rounded',
            max_width = 80,
            max_height = 20,
        },
    },
    
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        
        -- Tab through suggestions
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
    }),
    
    -- Sources (order matters for priority)
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },  -- LSP completions
        { name = 'luasnip' },   -- Snippets
        { name = 'buffer' },    -- Text within current buffer
        { name = 'path' },      -- File paths
    }),
    
    -- Better formatting with icons
    formatting = {
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format('%s %s', 
                ({
                    Text = '',
                    Method = '',
                    Function = '',
                    Constructor = '',
                    Field = '',
                    Variable = '',
                    Class = '',
                    Interface = '',
                    Module = '',
                    Property = '',
                    Unit = '',
                    Value = '',
                    Enum = '',
                    Keyword = '',
                    Snippet = '',
                    Color = '',
                    File = '',
                    Reference = '',
                    Folder = '',
                    EnumMember = '',
                    Constant = '',
                    Struct = '',
                    Event = '',
                    Operator = '',
                    TypeParameter = ''
                })[vim_item.kind] or '',
                vim_item.kind
            )
            
            -- Source name
            vim_item.menu = ({
                nvim_lsp = '[LSP]',
                luasnip = '[Snip]',
                buffer = '[Buf]',
                path = '[Path]',
            })[entry.source.name]
            
            return vim_item
        end,
    },
})
