return {
    plugin = {
        src = "https://github.com/stevearc/conform.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                bash = { "shfmt" },
                sh = { "shfmt" },
                javascript = { "oxfmt", "prettier", stop_after_first = true },
                typescript = { "oxfmt", "prettier", stop_after_first = true },
                javascriptreact = { "oxfmt", "prettier", stop_after_first = true },
                typescriptreact = { "oxfmt", "prettier", stop_after_first = true },
                json = { "oxfmt", "prettier", stop_after_first = true },
                jsonc = { "oxfmt", "prettier", stop_after_first = true },
                css = { "prettier" },
                scss = { "prettier" },
                html = { "prettier" },
                markdown = { "prettier" },
                ["markdown.mdx"] = { "prettier" },
                yaml = { "prettier" },
                glsl = { "clang_format" },
                zig = { "zigfmt" },
                go = { "goimports", "gofmt" },
                rust = { "rustfmt" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                toml = { "taplo" },
            },
            format_on_save = {
                timeout_ms = 1000,
                lsp_format = "fallback",
            },
            formatters = {
                clang_format = {
                    -- Only when the project has no .clang-format
                    prepend_args = function(_, ctx)
                        if
                            vim.fs.find({ ".clang-format", "_clang-format" }, { upward = true, path = ctx.dirname })[1]
                        then
                            return {}
                        end
                        return {
                            "--style={BasedOnStyle: LLVM, IndentWidth: 4, ColumnLimit: 120,"
                                .. " AllowShortFunctionsOnASingleLine: None, IndentPPDirectives: Leave}",
                        }
                    end,
                },
                shfmt = {
                    prepend_args = { "-i", "4", "-ci", "-sr" },
                },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
        })

        local conform = require("conform")
        vim.keymap.set(
            { "n", "v" },
            "<leader>cf",
            function() conform.format({ async = true }) end,
            { desc = "Format buffer (or selection)" }
        )
    end,
}
