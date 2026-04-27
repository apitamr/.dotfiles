return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Disable format on save (use <leader>fm for manual formatting)
      format_on_save = false,
      formatters_by_ft = {
        -- JS/TS (oxfmt, biome fallback)
        javascript = { "oxfmt", "biome", stop_after_first = true },
        javascriptreact = { "oxfmt", "biome", stop_after_first = true },
        typescript = { "oxfmt", "biome", stop_after_first = true },
        typescriptreact = { "oxfmt", "biome", stop_after_first = true },

        -- Web
        html = { "oxfmt" },
        css = { "oxfmt" },
        scss = { "oxfmt" },
        less = { "oxfmt" },
        json = { "oxfmt", "biome", stop_after_first = true },
        jsonc = { "oxfmt", "biome", stop_after_first = true },
        yaml = { "oxfmt" },
        markdown = { "oxfmt" },
        graphql = { "oxfmt" },

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
        xml = { "xmllint" },
        svg = { "xmllint" },
      },
      -- Customize formatters (merged with builtin formatters)
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" }, -- 2 spaces, indent switch cases
        },
      },
    },
  },
}
