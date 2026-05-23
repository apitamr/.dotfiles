return {
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    keys = {
      { "<leader>mt", "<cmd>Markview toggle<cr>", desc = "Toggle preview", ft = "markdown" },
      { "<leader>mh", "<cmd>Markview hybridToggle<cr>", desc = "Hybrid mode", ft = "markdown" },
      { "<leader>mv", "<cmd>Markview splitToggle<cr>", desc = "Split view", ft = "markdown" },
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      preview = {
        modes = { "n", "no", "c" }, -- Modes where markview is active
        callbacks = {
          on_enable = function(_, win)
            vim.wo[win].conceallevel = 2
            vim.wo[win].concealcursor = "c"
          end,
        },
      },
    },
  },
}
