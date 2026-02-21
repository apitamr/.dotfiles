return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      diagnostics = {
        update_in_insert = false,
        severity_sort = true,
        virtual_text = {
          spacing = 4,
          prefix = "●",
          source = "if_many",
        },
        float = {
          border = "rounded",
          source = "if_many",
          header = "",
          prefix = "",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
      },
      flags = {
        debounce_text_changes = 200,
      },
      servers = {
        vtsls = {
          settings = {
            typescript = {
              tsserver = {
                maxTsServerMemory = 2048,
              },
            },
          },
        },
      },
    },
  },
}
