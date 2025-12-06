return {
  {
    "dmtrKovalenko/fff.nvim",
    build = function()
      require("fff.download").download_or_build_binary()
    end,
    opts = {
      prompt = "> ",
      title = "FFFiles",
      max_results = 100,
      lazy_sync = true,
      layout = {
        height = 0.8,
        width = 0.8,
        prompt_position = "bottom",
        preview_position = "right",
        preview_size = 0.5,
      },
      preview = {
        enabled = true,
        line_numbers = true,
        wrap_lines = false,
        show_file_info = true,
      },
      keymaps = {
        close = "<Esc>",
        select = "<CR>",
        select_split = "<C-s>",
        select_vsplit = "<C-v>",
        select_tab = "<C-t>",
        move_up = { "<Up>", "<C-p>", "<C-k>" },
        move_down = { "<Down>", "<C-n>", "<C-j>" },
        preview_scroll_up = "<C-u>",
        preview_scroll_down = "<C-d>",
      },
      frecency = {
        enabled = true,
      },
      debug = {
        enabled = true,
        show_scores = true,
      },
    },
    lazy = false,
  },
}
