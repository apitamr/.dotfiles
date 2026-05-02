return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,

    opts = {
      default_file_explorer = true,
      columns = {
        "icon",
        { "size", highlight = "Special" },
      },
      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, _)
          return vim.startswith(name, ".")
        end,
      },
      win_options = {
        signcolumn = "no",
        number = true,
        relativenumber = true,
        numberwidth = 1,
        foldcolumn = "0",
        statuscolumn = "",
      },
      float = {
        padding = 2,
        max_width = 100,
        max_height = 30,
        border = "rounded",
      },
      keymaps = {
        ["q"] = "actions.close",
        ["<Esc>"] = {
          callback = function()
            local win = vim.api.nvim_get_current_win()
            local is_floating = vim.api.nvim_win_get_config(win).relative ~= ""
            -- Always close floating Oil
            if is_floating then
              vim.api.nvim_win_close(win, true)
              return
            end
            -- For non-floating, only close if there's another buffer
            local bufs = vim.fn.getbufinfo({ buflisted = 1 })
            local non_oil_bufs = vim.tbl_filter(function(buf)
              return vim.bo[buf.bufnr].filetype ~= "oil"
            end, bufs)
            if #non_oil_bufs > 0 then
              require("oil.actions").close.callback()
            end
          end,
          desc = "Close oil (always for float)",
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
