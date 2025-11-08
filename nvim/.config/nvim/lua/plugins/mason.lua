return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
      ensure_installed = {
        -- LSP Servers
        "clangd",
        "cmake-language-server",
        "css-lsp",
        "docker-compose-language-service",
        "docker-language-server",
        "html-lsp",
        "intelephense",
        "json-lsp",
        "lua-language-server",
        "prisma-language-server",
        "python-lsp-server",
        "rust-analyzer",
        "tailwindcss-language-server",
        "vtsls",
        "vue-language-server",
        "yaml-language-server",
        "zls",

        -- Formatters & Linters
        "biome",
        "htmlhint",
        "shfmt",
        "stylua",

        -- Tools
        "tree-sitter-cli",
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
    },
  },
}
