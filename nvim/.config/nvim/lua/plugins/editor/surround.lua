return {
  -- Disable LazyVim's default mini.surround
  { "nvim-mini/mini.surround", enabled = false },

  -- Use nvim-surround instead
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    init = function()
      -- Disable default insert-mode surrounds (must be set before plugin loads)
      vim.g.nvim_surround_no_insert_mappings = true
    end,
    opts = {},
  },
}
