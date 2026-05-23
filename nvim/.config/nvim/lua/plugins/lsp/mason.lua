return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
      ensure_installed = {
        -- LSP Servers
        "css-lsp",
        "docker-compose-language-service",
        "docker-language-server",
        "gopls",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "prisma-language-server",
        "rust-analyzer",
        "tailwindcss-language-server",
        "vtsls",
        "yaml-language-server",
        "zls",

        -- Formatters & Linters
        "stylua",
        "taplo",
        "oxlint",
        "oxfmt",

        -- Tools
        "tree-sitter-cli",
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_enable = true,
    },
  },
}
