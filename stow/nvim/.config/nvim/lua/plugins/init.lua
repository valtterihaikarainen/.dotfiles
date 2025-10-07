
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
local lsp = require("plugins.lsp")
local git = require("plugins.git")

-- 3) Concatenate them all into one big list 
local plugin_list = {}

-- helper function to merge multiple lists of tables
local function extend(dst, src)
    for _, val in ipairs(src) do
        table.insert(dst, val)
    end
end

extend(plugin_list, lsp)
extend(plugin_list, git)

-- 4) Finally, call lazy.nvim's setup
require("lazy").setup(plugin_list, {
    defaults = {
        lazy = true
    },
    dev = {},
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
