return {

    plugin = {
        src = "https://github.com/folke/trouble.nvim",
    },

    config = function()
        require("trouble").setup({
            focus = true,

            modes = {
                symbols = {
                    -- Upstream's list plus Variable, so Lua config files aren't empty
                    filter = {
                        -- lua_ls reuses Package for control-flow blocks
                        ["not"] = { ft = "lua", kind = "Package" },
                        any = {
                            ft = { "help", "markdown" },
                            kind = {
                                "Class",
                                "Constructor",
                                "Enum",
                                "Field",
                                "Function",
                                "Interface",
                                "Method",
                                "Module",
                                "Namespace",
                                "Package",
                                "Property",
                                "Struct",
                                "Trait",
                                "Variable",
                            },
                        },
                    },
                },
            },
        })

        local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end

        -- Upstream uses <leader>x, but that closes the buffer here (see bufferline.lua)
        map("<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", "Diagnostics (workspace)")
        map("<leader>tb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", "Diagnostics (buffer)")
        map("<leader>tl", "<cmd>Trouble loclist toggle<CR>", "Location list")
        map("<leader>tq", "<cmd>Trouble qflist toggle<CR>", "Quickfix list")
        map("<leader>ts", "<cmd>Trouble symbols toggle focus=false<CR>", "Symbols outline")
        map("<leader>tr", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", "LSP references/definitions")

        local trouble = require("trouble")
        map("]d", function()
            if trouble.is_open() then
                trouble.next({ jump = true })
            else
                vim.diagnostic.jump({ count = 1, float = true })
            end
        end, "Next diagnostic")
        map("[d", function()
            if trouble.is_open() then
                trouble.prev({ jump = true })
            else
                vim.diagnostic.jump({ count = -1, float = true })
            end
        end, "Previous diagnostic")
    end,
}
