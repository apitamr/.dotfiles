return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  cmd = { "FFFFind", "FFFScan" },
  opts = {
    prompt = "> ",
    lazy_sync = true, -- Start syncing only when picker is open
    debug = {
      enabled = false,
      show_scores = false,
    },
    keymaps = {
      move_up = { "<Up>", "<C-p>", "<C-k>" },
      move_down = { "<Down>", "<C-n>", "<C-j>" },
    },
  },
}
