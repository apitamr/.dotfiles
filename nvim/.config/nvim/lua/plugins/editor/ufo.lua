return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "VeryLazy",
    opts = {
      -- Use treesitter as the provider
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    },
    config = function(_, opts)
      -- Fold options
      vim.o.foldcolumn = "1" -- Show fold column
      vim.o.foldlevel = 99 -- Using ufo provider need a large value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup(opts)
    end,
  },
}
