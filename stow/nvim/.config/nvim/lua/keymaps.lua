-- space bar leader key
vim.g.mapleader = " "

-- buffers
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
vim.keymap.set("n", "<leader>x", ":bx<cr>")

-- yank to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])

-- Enter Ex 
vim.keymap.set("n", "<leader>pv", ":Ex<cr>")

-- Execute python files quickly
vim.keymap.set('n', '<leader>r', ':!python3 %<CR>')



-- telescope
vim.keymap.set("n", "<leader>fj", ":Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fp", ":Telescope git_files<cr>")
vim.keymap.set("n", "<leader>fk", ":Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fo", ":Telescope oldfiles<cr>")
vim.keymap.set(
  "n",
  "<leader>en",
  function()
    require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
  end,
  { desc = "Find files in NVIM config folder" }
)

-- buffers
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
vim.keymap.set("n", "<leader>x", ":bx<cr>")
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)


-- molten

vim.g.molten_auto_open_output = false



