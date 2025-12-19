return {
  -- Disable mini.pairs in favor of nvim-autopairs
  { "nvim-mini/mini.pairs", enabled = false },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      check_ts = true, -- use treesitter for smarter pairing
      map_bs = false, -- disable backspace mapping to prevent deleting pairs
    },
  },
}
