return {
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          enabled = true,
        },
      },
    },
    keys = {
      -- Disable default 's' and 'S' keymaps
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
      -- Use different keys for flash if you want to keep it
      {
        "<leader>s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "<leader>S",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
}
