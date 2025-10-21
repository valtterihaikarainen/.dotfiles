
vim.cmd.colorscheme("unokai")
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2D2A2E" }) 
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#75715E", bg = "#2D2A2E" })
vim.api.nvim_set_hl(0, "DiagnosticFloating", { link = "NormalFloat" })

vim.opt.winborder = "rounded"
vim.cmd(":hi statusline guibg=NONE")
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10

vim.opt.smartindent = true -- Smart auto-indenting
vim.opt.autoindent = true  -- Copy indent from current line

-- SEARCH SETTINGS
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true  -- Case sensitive if uppercase in search
vim.opt.hlsearch = false  -- Don't highlight search results
vim.opt.incsearch = true  -- Show matches as you type

-- VISUAL SETTINGS
vim.opt.termguicolors = true                  -- Enable 24-bit colors
-- vim.opt.signcolumn = "yes"                    -- Always show sign column
vim.opt.showmatch = true                      -- Highlight matching brackets
vim.opt.matchtime = 2                         -- How long to show matching bracket
vim.opt.cmdheight = 1                         -- Command line height
-- vim.opt.completeopt = "menu,menuone,noselect" -- Completion options
vim.opt.conceallevel = 0                      -- Don't hide markup
vim.opt.concealcursor = ""                    -- Don't hide cursor line markup
vim.opt.lazyredraw = true                     -- Don't redraw during macros
vim.opt.synmaxcol = 300                       -- Syntax highlighting limit
vim.opt.pumheight = 10                        -- Popup menu height

-- FILE HANDLING
vim.opt.backup = false                            -- Don't create backup files
vim.opt.writebackup = false                       -- Don't create backup before writing
vim.opt.swapfile = false                          -- Don't create swap files
vim.opt.undofile = true                           -- Persistent undo
vim.opt.undodir = vim.fn.expand("~/.vim/undodir") -- Undo directory
vim.opt.timeoutlen = 501                          -- Key timeout duration
vim.opt.ttimeoutlen = 0                           -- Key code timeout
vim.opt.autoread = true                           -- Auto reload files changed outside vim
vim.opt.autowrite = false                         -- Don't auto save

-- BEHAVIOR SETTINGS
vim.opt.hidden = true                   -- Allow hidden buffers
vim.opt.errorbells = false              -- No error bells
vim.opt.backspace = "indent,eol,start"  -- Better backspace behavior
vim.opt.autochdir = false               -- Don't auto change directory
vim.opt.iskeyword:append("-")           -- Treat dash as part of word
vim.opt.path:append("**")               -- include subdirectories in search
vim.opt.selection = "exclusive"         -- Selection behavior
vim.opt.mouse = "a"                     -- Enable mouse support
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard
vim.opt.modifiable = true               -- Allow buffer modifications
vim.opt.encoding = "UTF-8"              -- Set encoding

-- COMMAND-LINE COMPLETION
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.wildignore:append({ "*.o", "*.obj", "*.pyc", "*.class", "*.jar" })

-- BETTER DIFF OPTIONS
vim.opt.diffopt:append("linematch:60")

-- PERFORMANCE IMPROVEMENTS
vim.opt.redrawtime = 10000
vim.opt.maxmempattern = 20000

-- TAB DISPLAY SETTINGS
vim.opt.showtabline = 1
vim.opt.tabline = ''

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Write buffer" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<leader>o", ":so<CR>", { desc = "Source" })
vim.keymap.set("n", "<leader>b", ":bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>e", ":Explore<CR>", { desc = "Open file explorer" })

vim.keymap.set("n", "<leader>ff", ":find ", { desc = "Find file" })
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })

vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

vim.keymap.set("n", "<leader>rc", ":e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>stow", ":e ~/.dotfiles/stow/", { desc = "Edit stow" })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)

local augroup = vim.api.nvim_create_augroup("group", {})

-- HIGHLIGHT YANKED TEXT
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/christoomey/vim-tmux-navigator" },
	{ src = "https://github.com/lervag/vimtex" },
})

-- LSP SERVER SETUP
vim.lsp.enable({ "basedpyright", "lua_ls", "texlab", "clangd", "ts_ls", "rust_analyzer" })

vim.diagnostic.config({
  update_in_insert = true,  
  virtual_text = {
    spacing = 4,
    prefix = '●',
  },
  signs = true,
  underline = true,
  severity_sort = true,
  flat = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

vim.lsp.config("clangd", {
	cmd = { "clangd", "--background-index" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true)
			}
		}
	}
})

vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
				loadOutDirsFromCheck = true,
				buildScripts = {
					enable = true,
				},
			},
			checkOnSave = {
				command = "clippy",
			},
			procMacro = {
				enable = true,
			},
		},
	},
})

vim.lsp.config("texlab", {
	settings = {
		texlab = {
			chktex = {
				onOpenAndSave = true,
				onEdit = false,
			}
		}
	}
})


vim.lsp.config("basedpyright", {  
    settings = {
        basedpyright = {  
            analysis = {
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                reportAny = false,  
            }
        }
    }
})

vim.lsp.config("ts_ls", {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	settings = {
		javascript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
			}
		},
		typescript = {
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
			}
		}
	}
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- Enable completion with better settings
		if client and client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		-- LSP keymaps
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
		-- Manual trigger for completion if needed
		vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', opts)
	end,
})

-- PACKAGE RELATED SETTINGS
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_compiler_method = 'latexmk'
vim.g.vimtex_quickfix_mode = 0
