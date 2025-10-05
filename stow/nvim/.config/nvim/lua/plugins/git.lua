return {
    -- Fugitive - Git commands
    {
        'tpope/vim-fugitive',
        cmd = {'Git', 'G', 'Gdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse'},
        keys = {
            {'<leader>gs', '<cmd>Git<cr>', desc = 'Git status'},
            {'<leader>gc', '<cmd>Git commit<cr>', desc = 'Git commit'},
            {'<leader>gp', '<cmd>Git push<cr>', desc = 'Git push'},
            {'<leader>gP', '<cmd>Git pull<cr>', desc = 'Git pull'},
            {'<leader>gb', '<cmd>Git blame<cr>', desc = 'Git blame'},
            {'<leader>gd', '<cmd>Gdiffsplit<cr>', desc = 'Git diff'},
            {'<leader>gl', '<cmd>Git log<cr>', desc = 'Git log'},
        },
    },
    
    -- Gitsigns - Git decorations in sign column
    {
        'lewis6991/gitsigns.nvim',
        event = {'BufReadPre', 'BufNewFile'},
        config = function()
            require('gitsigns').setup({
                signs = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    
                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end
                    
                    -- Navigation
                    map('n', ']c', function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end, {expr=true, desc = 'Next hunk'})
                    
                    map('n', '[c', function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end, {expr=true, desc = 'Previous hunk'})
                    
                    -- Actions
                    map('n', '<leader>hs', gs.stage_hunk, {desc = 'Stage hunk'})
                    map('n', '<leader>hr', gs.reset_hunk, {desc = 'Reset hunk'})
                    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Stage hunk'})
                    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = 'Reset hunk'})
                    map('n', '<leader>hS', gs.stage_buffer, {desc = 'Stage buffer'})
                    map('n', '<leader>hu', gs.undo_stage_hunk, {desc = 'Undo stage hunk'})
                    map('n', '<leader>hR', gs.reset_buffer, {desc = 'Reset buffer'})
                    map('n', '<leader>hp', gs.preview_hunk, {desc = 'Preview hunk'})
                    map('n', '<leader>hb', function() gs.blame_line{full=true} end, {desc = 'Blame line'})
                    map('n', '<leader>hd', gs.diffthis, {desc = 'Diff this'})
                end
            })
        end
    },
    {
        'tpope/vim-rhubarb', -- GitHub support for GBrowse
        dependencies = {'tpope/vim-fugitive'},
        cmd = {'GBrowse'},
    },
}
