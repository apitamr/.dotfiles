return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          require("nvim-tree.api").tree.open()
        end,
      })
    end,
    opts = {
      hijack_netrw = true,
      modified = {
        enable = false,
      },
      git = {
        enable = false,
      },
      view = {
        side = "left",
        width = 30,
        signcolumn = "no",
      },
      renderer = {
        indent_markers = {
          enable = false,
        },
        icons = {
          padding = " ",
        },
      },
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      filters = {
        dotfiles = false,
        custom = { ".git" },
      },
      actions = {
        open_file = {
          quit_on_open = false,
        },
      },
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")
        api.config.mappings.default_on_attach(bufnr)
      end,
    },
  },
}
