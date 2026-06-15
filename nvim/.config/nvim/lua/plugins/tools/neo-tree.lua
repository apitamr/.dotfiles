return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-mini/mini.icons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    cmd = "Neotree",
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      enable_git_status = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { ".git", ".DS_Store" },
        },
        follow_current_file = { enabled = true, leave_dirs_open = true },
        hijack_netrw_behavior = "open_current",
        -- watch the filesystem so add/remove/rename show up without reopening
        use_libuv_file_watcher = true,
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      -- A commit only changes the git index, not files on disk, so the file
      -- watcher won't catch it. Re-run git status when focus returns (e.g.
      -- after committing in a terminal/lazygit) or when a terminal closes.
      vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
        group = vim.api.nvim_create_augroup("neotree_git_refresh", { clear = true }),
        callback = function()
          -- refresh() re-queries git because enable_git_status is on
          require("neo-tree.sources.manager").refresh("filesystem")
        end,
      })
    end,
  },
}
