return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    cmdline = {
      enabled = true,
      view = "cmdline", -- render at bottom (native-style), not popup
      format = {
        cmdline = { pattern = "^:", icon = ":", lang = "vim" },
        search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
        search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
        help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
      },
    },
    messages = { enabled = false },
    popupmenu = { enabled = false },
    notify = { enabled = false },
    lsp = {
      progress = { enabled = false },
      hover = { enabled = false },
      signature = { enabled = false },
      message = { enabled = false },
      smart_move = { enabled = false },
      documentation = { enabled = false },
    },
    health = { checker = false },
    presets = {
      bottom_search = true, -- search prompt at bottom too
      command_palette = false,
      long_message_to_split = false,
      inc_rename = false,
      lsp_doc_border = false,
    },
  },
}
