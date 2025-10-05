return {
  {
    "lervag/vimtex",
    ft = { "tex" },
    init = function()
      vim.g.maplocalleader = ","

      if vim.fn.has("mac") == 1 then
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_view_skim_sync = 1          -- jump to cursor after compile
        vim.g.vimtex_view_skim_reading_bar = 1   -- highlight line
        vim.g.vimtex_view_skim_activate = 0      -- ✨ don't steal focus; keeps Skim at the side
        vim.g.vimtex_view_forward_search_on_start = 1 -- do a forward search on first open
      else
        vim.g.vimtex_view_method = "zathura"
      end

      -- Let VimTeX/latexmk handle continuous builds
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "",
        callback = 1,
        continuous = 1,
        executable = "latexmk",
        options = { "-pdf", "-synctex=1", "-interaction=nonstopmode", "-file-line-error" },
      }

      vim.g.vimtex_quickfix_mode = 0
      -- (g:tex_flavor is no longer needed in recent VimTeX, safe to remove)
    end,
  },

  -- LSP (texlab) — keep diagnostics, but *disable* its on-save build to avoid duplicate latexmk
  {
    "neovim/nvim-lspconfig",
    ft = { "tex" },
    config = function()
      local lsp = require("lspconfig")
      lsp.texlab.setup({
        settings = {
          texlab = {
            build = {
              executable = "latexmk",
              args = { "-pdf", "-synctex=1", "-interaction=nonstopmode", "%f" },
              onSave = false,              -- 🔕 avoid double-compiling (VimTeX already runs continuous)
              forwardSearchAfter = false,  -- (handled by vimtex callback)
            },
            chktex = { onOpenAndSave = true, onEdit = false },
            diagnosticsDelay = 150,
            forwardSearch = (function()
              if vim.fn.has("mac") == 1 then
                return {
                  executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
                  args = { "-r", "%l", "%p", "%f" }, -- reuse existing Skim window
                }
              else
                return {
                  executable = "zathura",
                  args = { "--synctex-forward", "%l:1:%f", "%p" },
                }
              end
            end)(),
            latexFormatter = "latexindent",
            latexindent = { modifyLineBreaks = true },
          },
        },
      })
    end,
  },
}
