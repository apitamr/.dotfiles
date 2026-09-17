return {

    plugin = {
        { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.x") },
        { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.x") },
        { src = "https://github.com/rafamadriz/friendly-snippets" },
    },

    config = function()
        -- Deferred until after startup
        vim.api.nvim_create_autocmd("VimEnter", {
            group = vim.api.nvim_create_augroup("completion-deferred", { clear = true }),
            once = true,
            callback = function()
                vim.schedule(function()
                    require("luasnip").setup({})
                    require("luasnip.loaders.from_vscode").lazy_load()

                    require("blink.cmp").setup({
                        keymap = {
                            preset = "enter",
                            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                        },

                        snippets = { preset = "luasnip" },

                        sources = {
                            default = { "lsp", "path", "snippets", "buffer" },
                        },

                        completion = {
                            menu = {
                                border = "single",
                                scrollbar = false,
                                draw = {
                                    columns = {
                                        { "label", "label_description", gap = 1 },
                                        { "kind_icon", "kind", gap = 1 },
                                    },
                                },
                            },
                            documentation = {
                                auto_show = true,
                                auto_show_delay_ms = 200,
                                window = { border = "single", scrollbar = false },
                            },
                        },

                        cmdline = {
                            completion = {
                                menu = { auto_show = true },
                                -- A preselected item would rewrite the cmdline and <CR> would run it
                                list = { selection = { preselect = false, auto_insert = false } },
                            },
                        },

                        signature = {
                            enabled = true,
                            window = { show_documentation = false },
                        },
                    })
                end)
            end,
        })
    end,
}
