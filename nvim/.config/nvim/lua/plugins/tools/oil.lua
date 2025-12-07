return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,

    opts = {
      default_file_explorer = true,
      columns = { "icon" },
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, _)
          return vim.startswith(name, ".")
        end,
      },
      float = {
        padding = 2,
        max_width = 100,
        max_height = 30,
        border = "rounded",
      },
      keymaps = {
        ["q"] = {
          callback = function()
            -- Only close if there's another buffer to return to
            local bufs = vim.fn.getbufinfo({ buflisted = 1 })
            local non_oil_bufs = vim.tbl_filter(function(buf)
              return vim.bo[buf.bufnr].filetype ~= "oil"
            end, bufs)
            if #non_oil_bufs > 0 then
              require("oil.actions").close.callback()
            end
          end,
          desc = "Close oil if other buffers exist",
        },
        ["<Esc>"] = {
          callback = function()
            -- Only close if there's another buffer to return to
            local bufs = vim.fn.getbufinfo({ buflisted = 1 })
            local non_oil_bufs = vim.tbl_filter(function(buf)
              return vim.bo[buf.bufnr].filetype ~= "oil"
            end, bufs)
            if #non_oil_bufs > 0 then
              require("oil.actions").close.callback()
            end
          end,
          desc = "Close oil if other buffers exist",
        },
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-v>"] = "actions.select_vsplit",
        ["<C-s>"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-r>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      use_default_keymaps = false,
    },
  },
}
