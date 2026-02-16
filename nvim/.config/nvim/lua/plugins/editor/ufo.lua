return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "BufReadPost", -- Load only when reading a file
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
    },
    opts = {
      -- Use indent as primary (lighter than treesitter), treesitter as fallback
      provider_selector = function(bufnr, filetype, buftype)
        -- Skip for special buffers
        if buftype ~= "" then
          return ""
        end
        return { "indent" }
      end,
      -- Reduce fold update frequency
      close_fold_kinds_for_ft = {},
      open_fold_hl_timeout = 0,
    },
    config = function(_, opts)
      vim.o.foldcolumn = "0" -- Hide fold column (reduces rendering)
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup(opts)
    end,
  },
}
