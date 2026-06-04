return {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>gb", "<cmd>GitBlameToggle<cr>", desc = "Blame" },
      { "<leader>gB", "<cmd>GitBlameOpenCommitURL<cr>", desc = "Blame URL" },
      { "<leader>gC", "<cmd>GitBlameCopySHA<cr>", desc = "Copy SHA" },
    },
    opts = {
      enabled = true,
      message_template = " <summary> • <date> • <author>",
      message_when_not_committed = "",
      date_format = "%r",
      virtual_text_column = 1,
      delay = 0,
    },
  },
}
