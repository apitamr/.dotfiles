return {

    plugin = {
        { src = "https://github.com/nvim-tree/nvim-web-devicons" },
        { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    },

    config = function()
        require("render-markdown").setup({
            file_types = { "markdown" },
        })

        vim.keymap.set("n", "<leader>mv", "<cmd>RenderMarkdown buf_toggle<CR>", { desc = "Toggle markdown view" })
    end,
}
