vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {

    plugin = {
        { src = "https://github.com/nvim-tree/nvim-web-devicons" },
        { src = "https://github.com/nvim-tree/nvim-tree.lua" },
    },

    config = function()
        require("nvim-web-devicons").setup({})

        -- Setup costs ~10ms, so it waits until after startup
        local built = false
        local function build()
            if built then
                return
            end
            built = true

            require("nvim-tree").setup({
                on_attach = function(bufnr)
                    require("nvim-tree.api").config.mappings.default_on_attach(bufnr)
                    -- Free <C-k> for window navigation
                    vim.keymap.del("n", "<C-k>", { buffer = bufnr })
                end,
                hijack_cursor = true,
                sync_root_with_cwd = true,
                update_focused_file = {
                    enable = true,
                    update_root = false,
                },
                view = {
                    width = 30,
                    preserve_window_proportions = true,
                },
                renderer = {
                    root_folder_label = false,
                    highlight_git = true,
                    icons = { show = { git = false } },
                    indent_markers = {
                        enable = true,
                        icons = { corner = "┆", edge = "┆", item = "┆", none = " " },
                    },
                },
                filters = { dotfiles = false },
            })
        end

        -- `nvim <dir>` needs the tree right away, since netrw is disabled
        if vim.fn.isdirectory(vim.fn.argv(0) or "") == 1 then
            build()
        else
            vim.api.nvim_create_autocmd("VimEnter", {
                group = vim.api.nvim_create_augroup("nvim-tree-deferred", { clear = true }),
                once = true,
                callback = function() vim.schedule(build) end,
            })
        end

        vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

        vim.keymap.set("n", "<leader>e", function()
            local api = require("nvim-tree.api")
            if vim.bo.filetype == "NvimTree" then
                api.tree.close()
            else
                api.tree.focus()
            end
        end, { desc = "Toggle/focus file explorer" })
    end,
}
