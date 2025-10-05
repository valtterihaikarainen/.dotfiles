
 -- 1) Bootstrap lazy.nvim if not already present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then 
    print("lazy.nvim not found at " .. lazypath)
    vim.fn.system({
        "git", 
        "clone", 
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath) -- Prepend lazy to runtime path

-- 2) Import each plugin-spec module 
local telescope = require("plugins.telescope")
local ui_plugins = require("plugins.ui")
local lsp = require("plugins.lsp")
local jupyter = require("plugins.jupyter")
local jupytext = require("plugins.jupytext")
local quarto = require("plugins.quarto")
local latex = require("plugins.latex")
local tmux = require("plugins.tmux")
local git = require("plugins.git")
local smear_cursor = require("plugins.smear_cursor")

-- 3) Concatenate them all into one big list 
local plugin_list = {}

-- helper function to merge multiple lists of tables
local function extend(dst, src)
    for _, val in ipairs(src) do
        table.insert(dst, val)
    end
end

extend(plugin_list, ui_plugins)
extend(plugin_list, telescope)
extend(plugin_list, lsp)
extend(plugin_list, jupyter)
extend(plugin_list, jupytext)
extend(plugin_list, quarto)
extend(plugin_list, latex)
extend(plugin_list, tmux)
extend(plugin_list, git)
extend(plugin_list, smear_cursor)

-- ... more

-- 4) Finally, call lazy.nvim's setup
require("lazy").setup(plugin_list, {
    defaults = {
        lazy = true
    },
    dev = {},
    install = {
        colorscheme = { "gruvbox-community/gruvbox" }
    },
    checker = {
        enabled = true, -- automatically check for plugin updates
        concurrency = nil, -- how many processes to spawn for checking
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

 
