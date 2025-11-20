-- Source existing vimrc
vim.cmd('source ~/.dotfiles/common/.config/vim/vimrc')

-- ============================================================================
-- Basic Settings
-- ============================================================================
vim.opt.termguicolors = false
vim.opt.updatetime = 250
vim.opt.winborder = "rounded"

-- ============================================================================
-- Highlight Groups
-- ============================================================================
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2D2A2E" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#75715E", bg = "#2D2A2E" })
vim.api.nvim_set_hl(0, "DiagnosticFloating", { link = "NormalFloat" })

-- ============================================================================
-- Autocommands
-- ============================================================================
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd('CursorHold', {
	group = augroup,
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

-- ============================================================================
-- Bootstrap lazy.nvim
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Plugin Specifications
-- ============================================================================
require("lazy").setup({
	-- Colorscheme
	{
		"folke/tokyonight.nvim",
		priority = 1000,
		config = function()
			vim.cmd[[colorscheme tokyonight]]
		end,
	},

	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Configure basedpyright LSP
			vim.lsp.config.basedpyright = {
				cmd = { 'basedpyright-langserver', '--stdio' },
				filetypes = { 'python' },
				root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "standard",
							autoImportCompletions = true,
							autoSearchPaths = true,
							diagnosticMode = "openFilesOnly",
							useLibraryCodeForTypes = true,
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

			vim.lsp.enable('basedpyright')
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require('nvim-treesitter.configs').setup({
				ensure_installed = { "lua", "python", "vim", "vimdoc" },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
			})
		end,
	},

	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			require('telescope').setup({})
			-- Load fzf extension if available
			pcall(require('telescope').load_extension, 'fzf')
		end,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
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
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
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

				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
					{ name = 'buffer' },
					{ name = 'path' },
				}),

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
		end,
	},

	-- ============================================================================
	-- Avante.nvim - AI-powered code assistance (emulates Cursor AI IDE)
	-- ============================================================================
	-- Setup Instructions:
	--   1. Set your Claude API key as an environment variable:
	--      export ANTHROPIC_API_KEY=your-api-key
	--      (or use AVANTE_ANTHROPIC_API_KEY for scoped keys)
	--
	--   2. Key bindings (default):
	--      <leader>aa - Ask AI about code
	--      <leader>ae - Edit selected code
	--      <leader>at - Toggle sidebar
	--      <leader>ar - Refresh sidebar
	--      <leader>ad - Toggle debug mode
	--
	--   3. Features:
	--      - AI-powered code suggestions
	--      - Apply changes with one click
	--      - Project-specific instructions via avante.md file
	--      - @codebase - chat with entire project
	--      - @file - add specific files to context
	--
	-- See: https://github.com/yetone/avante.nvim for full documentation
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		build = "make",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope.nvim",
			"hrsh7th/nvim-cmp",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
			{
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						use_absolute_path = true,
					},
				},
			},
		},
		opts = {
			provider = "claude",
			providers = {
				claude = {
					endpoint = "https://api.anthropic.com",
					model = "claude-sonnet-4-5-20250929",
					timeout = 30000,
					extra_request_body = {
						temperature = 0.75,
						max_tokens = 20480,
					},
				},
			},
			behaviour = {
				auto_suggestions = false,
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = false,
			},
			mappings = {
				ask = "<leader>aa",
				edit = "<leader>ae",
				refresh = "<leader>ar",
				toggle = {
					default = "<leader>at",
					debug = "<leader>ad",
					hint = "<leader>ah",
					suggestion = "<leader>as",
				},
			},
			windows = {
				position = "right",
				wrap = true,
				width = 30,
			},
		},
	},

	-- Utility plugins
	"christoomey/vim-tmux-navigator",
	"tpope/vim-surround",
	{
		"lervag/vimtex",
		ft = "tex",
	},
})
