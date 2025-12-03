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
      { "<leader>o", group = "opencode" },
      { "<leader>p", group = "paste" },
      { "<leader>t", group = "triforce" },
      { "<leader>x", hidden = true }, -- hide LazyVim's diagnostics group, we use it for close buffer
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
