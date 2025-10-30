return {
  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true, -- Enable git blame on startup
      message_template = " <summary> • <date> • <author>", -- Template for the blame message
      date_format = "%r", -- Relative date format
      virtual_text_column = 1, -- Virtual text column position
    },
  },
}
