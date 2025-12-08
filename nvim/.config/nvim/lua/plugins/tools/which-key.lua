return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 0,
    spec = {
      { "<leader>f", group = "find/files" },
      { "<leader>g", group = "git" },
      { "<leader>d", group = "diagnostics" },
      { "<leader>m", group = "markdown/marks" },
      { "<leader>u", group = "utils" },
      { "<leader>o", group = "oil" },
      { "<leader>p", group = "paste" },
      { "<leader>t", group = "triforce" },
      -- Completely disable <leader>x group so our close buffer mapping works instantly
      { "<leader>x", group = false, hidden = true },
    },
  },
}
