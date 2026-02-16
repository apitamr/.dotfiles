return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = {
        update_in_insert = false, -- Don't update diagnostics in insert mode
        virtual_text = {
          spacing = 4,
          prefix = "●",
        },
      },
      -- Reduce LSP overhead
      flags = {
        debounce_text_changes = 200, -- Wait 200ms before sending changes
      },
    },
  },
}
