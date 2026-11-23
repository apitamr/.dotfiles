return {

    plugin = {
        src = "https://github.com/akinsho/bufferline.nvim",
    },

    config = function()
        require("bufferline").setup({
            options = {
                numbers = "ordinal",
                diagnostics = "nvim_lsp",
                show_buffer_close_icons = true,
                always_show_bufferline = true,
                indicator = { style = "none" },
                offsets = {
                    {
                        filetype = "NvimTree",
                        text = function()
                            local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
                            return "\u{F07C} " .. (name == "" and "/" or name)
                        end,
                        highlight = "Directory",
                        separator = false,
                    },
                },
            },
        })

        -- Close the buffer but keep its window
        local function close_buffer()
            local buf = vim.api.nvim_get_current_buf()

            -- Side panes are unlisted, and deleting one closes its window
            if not vim.bo[buf].buflisted then
                return
            end

            local listed = vim.tbl_filter(function(b) return vim.bo[b].buflisted end, vim.api.nvim_list_bufs())

            if #listed > 1 then
                vim.cmd("BufferLineCyclePrev")
            else
                vim.cmd("enew")
            end
            vim.cmd("bdelete " .. buf)
        end

        -- <S-h>/<S-l> instead of <Tab> so <C-i> (jumplist forward) keeps working
        vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
        vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer" })
        -- Any index, including past 9: :Buf 12
        vim.api.nvim_create_user_command("Buf", function(opts)
            local index = tonumber(opts.args)
            if not index or index < 1 or index % 1 ~= 0 then
                vim.notify("Buffer index must be a positive integer", vim.log.levels.WARN)
                return
            end
            vim.cmd("BufferLineGoToBuffer " .. index)
        end, { nargs = 1, desc = "Go to buffer by its bar index" })
        vim.keymap.set("n", "<leader>x", close_buffer, { desc = "Close buffer" })
        vim.keymap.set("n", "<leader>b", "<cmd>enew<CR>", { desc = "New buffer" })
    end,
}
