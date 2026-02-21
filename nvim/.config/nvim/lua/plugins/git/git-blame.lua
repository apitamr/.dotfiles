return {
  {
    "f-person/git-blame.nvim",
    cmd = { "GitBlameToggle", "GitBlameEnable", "GitBlameDisable", "GitBlameOpenCommitURL", "GitBlameCopySHA" },
    opts = {
      enabled = false, -- Disable on startup, toggle manually with :GitBlameToggle
      message_template = " <summary> • <date> • <author>",
      date_format = "%r",
      virtual_text_column = 1,
      delay = 500, -- Delay in ms before showing blame (reduces CPU usage)
    },
  },
}
