-- Update tmux status line with Neovim mode
if vim.env.TMUX then
  local function update_tmux_statusline()
    local mode = vim.api.nvim_get_mode().mode
    local mode_map = {
      n = "NORMAL",
      i = "INSERT",
      v = "VISUAL",
      V = "V-LINE",
      ["\22"] = "V-BLOCK", -- Ctrl-V
      c = "COMMAND",
      R = "REPLACE",
      t = "TERMINAL",
      s = "SELECT",
      S = "S-LINE",
    }
    local mode_name = mode_map[mode] or mode
    vim.fn.system('tmux set-option -g status-right "#[fg=cyan]' .. mode_name .. ' #[fg=black bg=yellow] %Y-%m-%d %H:%M "')
  end

  vim.api.nvim_create_autocmd("ModeChanged", {
    pattern = "*",
    callback = update_tmux_statusline,
  })
  
  -- Update on initial load
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = update_tmux_statusline,
  })
end
