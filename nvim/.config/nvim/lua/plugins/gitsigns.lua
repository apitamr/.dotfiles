return {

    plugin = {
        src = "https://github.com/lewis6991/gitsigns.nvim",
    },

    config = function()
        require("gitsigns").setup({
            on_attach = function(bufnr)
                local gs = require("gitsigns")
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                map("n", "]h", function() gs.nav_hunk("next") end, "Next git hunk")
                map("n", "[h", function() gs.nav_hunk("prev") end, "Previous git hunk")
                map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                map({ "n", "v" }, "<leader>hs", gs.stage_hunk, "Stage hunk")
                map({ "n", "v" }, "<leader>hr", gs.reset_hunk, "Reset hunk")
                map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
                map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
                map("n", "<leader>hd", gs.diffthis, "Diff against index")
            end,
        })
    end,
}
