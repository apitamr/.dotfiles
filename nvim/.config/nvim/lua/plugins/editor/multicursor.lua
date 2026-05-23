return {
  "brenton-leighton/multiple-cursors.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {},
  keys = {
    -- Note: For Ghostty on macOS, add to ~/.config/ghostty/config:
    --   macos-option-as-alt = true
    { "<A-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = { "n", "x" }, desc = "Add cursor above" },
    { "<A-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = { "n", "x" }, desc = "Add cursor below" },
    { "<A-S-k>", "<Cmd>MultipleCursorsAddUpSkip<CR>", mode = { "n", "x" }, desc = "Skip cursor above" },
    { "<A-S-j>", "<Cmd>MultipleCursorsAddDownSkip<CR>", mode = { "n", "x" }, desc = "Skip cursor below" },

    { "<leader>mn", "<Cmd>MultipleCursorsAddJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Match add cursor (next)" },
    { "<leader>mj", "<Cmd>MultipleCursorsJumpNextMatch<CR>", mode = { "n", "x" }, desc = "Match skip cursor (next)" },

    { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = { "n", "i" }, desc = "Add/remove cursor with mouse" },

    { "ga", "<Cmd>MultipleCursorsAddMatches<CR>", mode = { "n", "x" }, desc = "Match all add cursors" },
    { "<leader>mA", "<Cmd>MultipleCursorsAddMatchesV<CR>", mode = { "n", "x" }, desc = "Match all in prev visual area" },

    { "<leader>ml", "<Cmd>MultipleCursorsLock<CR>", mode = { "n", "x" }, desc = "Lock/unlock virtual cursors" },
  },
}
