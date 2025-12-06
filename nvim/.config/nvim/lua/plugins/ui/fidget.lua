return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        display = {
          render_limit = 16, -- Maximum number of messages to render
          done_ttl = 3, -- How long to keep messages after completion (seconds)
          done_icon = "✔", -- Icon for completed tasks
          progress_icon = {
            pattern = "dots",
            period = 1,
          },
          group_style = "Title", -- Highlight group for group names
          icon_style = "Question", -- Highlight group for icons
          priority = 30, -- Ordering priority for LSP notification group
          skip_history = true, -- Don't add to fidget history
        },
        lsp = {
          progress_ringbuf_size = 0, -- Disable LSP progress ring buffer
        },
      },
      notification = {
        window = {
          normal_hl = "Comment", -- Base highlight group
          winblend = 0, -- Background color opacity (0-100)
          border = "none",
          zindex = 45,
          max_width = 0, -- Maximum width (0 = no limit)
          max_height = 0, -- Maximum height (0 = no limit)
          x_padding = 1,
          y_padding = 0,
          align = "bottom", -- bottom|top|avoid_cursor
          relative = "editor", -- editor|win
        },
      },
    },
  },
}
