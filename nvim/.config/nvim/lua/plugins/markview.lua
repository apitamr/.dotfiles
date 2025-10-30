return {
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended to load immediately for markdown files
    ft = "markdown", -- Load only for markdown files
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      preview = {
        modes = { "n", "no", "c" }, -- Modes where markview is active
        hybrid_modes = { "n" }, -- Hybrid mode shows raw markdown on cursor line
        
        -- Callbacks for when markview is attached/detached
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
