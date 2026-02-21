return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300,
    sort = { "alphanum" },
    icons = {
      mappings = false,
      keys = {},
    },
    spec = {
      { "<leader>a", group = "ai" },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "diagnostics" },
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>gh", group = "hunks" },
      { "<leader>m", group = "markdown" },
      { "<leader>p", group = "paste" },
      { "<leader>q", group = "quit/quickfix" },
      { "<leader>s", group = "search" },
      { "<leader>u", group = "utils" },
      { "<leader>w", group = "window" },
      { "<leader>x", group = "trouble" },
      { "gs", group = "symbols" },
    },
  },
}
