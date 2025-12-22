return {
  "saghen/blink.cmp",
  opts = {
    sources = {
      default = { "buffer" },
      providers = {
        path = { enabled = false },
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
        function() -- sidekick next edit suggestion
          return require("sidekick").nes_jump_or_apply()
        end,
        "accept",
        "fallback",
      },
    },
  },
}
