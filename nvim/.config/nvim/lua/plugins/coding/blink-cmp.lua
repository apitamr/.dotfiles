return {
  "saghen/blink.cmp",
  opts = {
    sources = {
      default = { "lsp", "snippets", "buffer", "path" },
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },
      list = {
        selection = { preselect = true, auto_insert = false },
      },
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", gap = 1 } },
        },
      },
    },
    keymap = {
      preset = "default",
      ["<Tab>"] = {
        "snippet_forward",
        "select_next",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      ["<CR>"] = {
        function()
          return require("sidekick").nes_jump_or_apply()
        end,
        "accept",
        "fallback",
      },
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
  },
}
