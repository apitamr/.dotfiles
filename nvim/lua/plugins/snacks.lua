return {

    plugin = {
        src = "https://github.com/folke/snacks.nvim",
    },

    config = function()
        require("snacks").setup({
            picker = {
                enabled = true,
                actions = {
                    trouble_open = function(...)
                        return require("trouble.sources.snacks").actions.trouble_open.action(...)
                    end,
                },
                win = {
                    input = {
                        keys = {
                            ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
                        },
                    },
                },
            },
            indent = {
                enabled = true,
                -- ┊ and ╎ break up in Ghostty's taller cells
                indent = { char = "┆" },
                scope = { char = "┆" },
                animate = { enabled = false },
            },
            lazygit = { enabled = true },
            notifier = { enabled = true },
            words = { enabled = true },
            bigfile = { enabled = true },
            -- Ghostty's kitty graphics protocol; tmux needs allow-passthrough
            image = { enabled = true },
            explorer = { enabled = false },
        })

        -- The theme's guide color is nearly invisible
        local function guide_colors()
            vim.api.nvim_set_hl(0, "SnacksIndent", { link = "Whitespace" })
            vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "LineNr" })
        end
        guide_colors()
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("snacks-guide-colors", { clear = true }),
            callback = guide_colors,
        })

        local picker = require("snacks").picker
        local map = function(lhs, fn, desc) vim.keymap.set("n", lhs, fn, { desc = desc }) end

        -- <leader>ff/fw are in fff.lua
        map("<leader>fa", function() picker.files({ hidden = true, ignored = true }) end, "Find all files")
        map("<leader>fb", function() picker.buffers() end, "Find buffers")
        map("<leader>fo", function() picker.recent() end, "Recent files")
        map("<leader>fh", function() picker.help() end, "Help pages")
        map("<leader>fz", function() picker.lines() end, "Search current buffer")
        map("<leader>fk", function() picker.keymaps() end, "Keymaps")
        map("<leader>fd", function() picker.diagnostics() end, "Diagnostics")
        map("<leader>fr", function() picker.resume() end, "Resume last picker")

        map("<leader>gt", function() picker.git_status() end, "Git status")
        map("<leader>cm", function() picker.git_log() end, "Git commits")
        map("<leader>gg", function() Snacks.lazygit() end, "Lazygit")

        map("<leader>fn", function() Snacks.notifier.show_history() end, "Notification history")

        map("]r", function() Snacks.words.jump(1) end, "Next reference")
        map("[r", function() Snacks.words.jump(-1) end, "Previous reference")

        map("grr", function() picker.lsp_references() end, "References")
        map("<leader>fs", function() picker.lsp_symbols() end, "Document symbols")
    end,
}
