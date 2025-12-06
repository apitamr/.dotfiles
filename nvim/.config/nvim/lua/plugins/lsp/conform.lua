return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Disable format on save (use <leader>fm for manual formatting)
      format_on_save = false,
      formatters_by_ft = {
        -- JavaScript/TypeScript (Biome or Prettier)
        javascript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        typescript = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },

        -- Web
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        json = { "biome", "prettier", stop_after_first = true },
        jsonc = { "biome", "prettier", stop_after_first = true },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },

        -- Lua
        lua = { "stylua" },

        -- Python
        python = { "isort", "black" },

        -- Go
        go = { "gofumpt", "goimports" },

        -- Rust
        rust = { "rustfmt" },

        -- Shell
        sh = { "shfmt" },
        bash = { "shfmt" },

        -- Other
        toml = { "taplo" },
        xml = { "xmlformat" },
      },
      -- Customize formatters (merged with builtin formatters)
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" }, -- 2 spaces, indent switch cases
        },
        prettier = {
          prepend_args = { "--tab-width", "2", "--single-quote" },
        },
      },
    },
  },
}
