return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    require("fff.download").download_or_build_binary()
  end,
  cmd = { "FFFFind", "FFFScan" },
  config = function(_, opts)
    require("fff").setup(opts)
    local image = require("fff.file_picker.image")
    local orig_is_image = image.is_image
    image.is_image = function(file_path)
      if type(file_path) == "string" and file_path:lower():match("%.svg$") then
        return true
      end
      return orig_is_image(file_path)
    end
  end,
  opts = {
    prompt = "> ",
    lazy_sync = true, -- Start syncing only when picker is open
    layout = {
      prompt_position = "top",
    },
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
