return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = "BufReadPost",
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Fold less" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Fold more" },
      { "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek fold" },
    },
    opts = {
      -- Treesitter for structured languages, indent as universal fallback
      provider_selector = function(_, filetype, buftype)
        if buftype ~= "" then
          return ""
        end
        -- Languages where treesitter folding is reliable
        local ts_langs = {
          "lua", "python", "javascript", "typescript", "typescriptreact",
          "javascriptreact", "go", "rust", "c", "cpp", "json", "yaml",
          "html", "css", "vue", "tsx", "jsx", "ruby", "php", "zig",
        }
        for _, lang in ipairs(ts_langs) do
          if filetype == lang then
            return { "treesitter", "indent" }
          end
        end
        return { "indent" }
      end,
      close_fold_kinds_for_ft = {},
      open_fold_hl_timeout = 0,
    },
    config = function(_, opts)
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      require("ufo").setup(opts)
    end,
  },
}
