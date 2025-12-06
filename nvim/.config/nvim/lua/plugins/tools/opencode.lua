return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      { "folke/snacks.nvim" },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any
      }

      -- Required for `opts.events.reload`.
      vim.o.autoread = true
    end,
  },

  -- Ensure snacks.nvim has the required features enabled
  {
    "folke/snacks.nvim",
    opts = {
      picker = {},
      terminal = {},
    },
  },
}
