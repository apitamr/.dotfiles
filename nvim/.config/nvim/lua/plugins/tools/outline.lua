return {
  {
    "hedyhli/outline.nvim",
    lazy = false,
    opts = {
      outline_window = {
        position = "left",
        width = 35,
        auto_close = false,
        focus_on_open = false,
        relative_width = false,
        no_provider_message = "",
      },
    },
    config = function(_, opts)
      require("outline").setup(opts)

      -- Auto-open outline when opening a file
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          -- Skip special buffers
          local buftype = vim.bo.buftype
          local filetype = vim.bo.filetype
          if buftype ~= "" or filetype == "Outline" or filetype == "" then
            return
          end
          -- Defer to ensure LSP is attached
          vim.defer_fn(function()
            local outline = require("outline")
            if not outline.is_open() then
              vim.cmd("OutlineOpen")
            end
          end, 100)
        end,
      })

      -- Auto-close outline when it's the last window
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          local function count_normal_windows()
            local count = 0
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local config = vim.api.nvim_win_get_config(win)
              if config.relative == "" then
                count = count + 1
              end
            end
            return count
          end
          if vim.bo.filetype == "Outline" and count_normal_windows() == 1 then
            vim.cmd("q")
          end
        end,
      })
    end,
  },
}
