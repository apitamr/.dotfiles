return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Disable format on save (use <leader>fm for manual formatting)
      format_on_save = false,
      formatters_by_ft = {
        -- JS/TS (oxfmt → biome → prettier)
        javascript = { "oxfmt", "biome", "prettier", stop_after_first = true },
        javascriptreact = { "oxfmt", "biome", "prettier", stop_after_first = true },
        typescript = { "oxfmt", "biome", "prettier", stop_after_first = true },
        typescriptreact = { "oxfmt", "biome", "prettier", stop_after_first = true },

        -- Web
        html = { "oxfmt", "biome", "prettier", stop_after_first = true },
        css = { "oxfmt", "biome", "prettier", stop_after_first = true },
        scss = { "oxfmt", "biome", "prettier", stop_after_first = true },
        less = { "oxfmt", "biome", "prettier", stop_after_first = true },
        json = { "oxfmt", "biome", "prettier", stop_after_first = true },
        jsonc = { "oxfmt", "biome", "prettier", stop_after_first = true },
        yaml = { "oxfmt", "biome", "prettier", stop_after_first = true },
        markdown = { "oxfmt", "biome", "prettier", stop_after_first = true },
        graphql = { "oxfmt", "biome", "prettier", stop_after_first = true },

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
        prettier = {
          command = function(_, ctx)
            local local_bin = vim.fs.find("node_modules/.bin/prettier", {
              upward = true,
              path = ctx.dirname,
            })[1]
            return local_bin or "prettier"
          end,
        },
        biome = {
          command = function(_, ctx)
            local local_bin = vim.fs.find("node_modules/.bin/biome", {
              upward = true,
              path = ctx.dirname,
            })[1]
            return local_bin or "biome"
          end,
          condition = function(_, ctx)
            return vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yaml",
              ".prettierrc.yml",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              ".prettierrc.toml",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
            }, { upward = true, path = ctx.dirname })[1] == nil
          end,
        },
        oxfmt = {
          command = function(_, ctx)
            local local_bin = vim.fs.find("node_modules/.bin/oxfmt", {
              upward = true,
              path = ctx.dirname,
            })[1]
            return local_bin or "oxfmt"
          end,
          condition = function(_, ctx)
            return vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yaml",
              ".prettierrc.yml",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              ".prettierrc.toml",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
              "biome.json",
              "biome.jsonc",
            }, { upward = true, path = ctx.dirname })[1] == nil
          end,
        },
      },
    },
  },
}
