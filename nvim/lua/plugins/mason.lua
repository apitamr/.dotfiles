return {

    plugin = {
        { src = "https://github.com/mason-org/mason.nvim" },
        { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
        { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    },

    config = function()
        require("mason").setup({})
        -- Otherwise stylua also attaches as a language server; lsp.lua enables servers
        require("mason-lspconfig").setup({ automatic_enable = false })
        require("mason-tool-installer").setup({
            ensure_installed = {
                -- Servers
                "lua_ls",
                "bashls",
                "vtsls",
                "oxlint",
                "tailwindcss",
                "html",
                "cssls",
                "jsonls",
                "yamlls",

                -- Tools
                -- Needed by nvim-treesitter to build parsers
                "tree-sitter-cli",

                -- Formatters and linters
                "shellcheck",
                "stylua",
                "shfmt",
                "oxfmt",
                "prettier",
            },
        })
    end,
}
