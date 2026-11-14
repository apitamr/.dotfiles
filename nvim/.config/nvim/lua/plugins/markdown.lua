return {

    plugin = {
        { src = "https://github.com/nvim-tree/nvim-web-devicons" },
        { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    },

    config = function()
        vim.filetype.add({ extension = { mdx = "markdown.mdx", mdc = "markdown" } })
        vim.treesitter.language.register("markdown", "markdown.mdx")

        require("render-markdown").setup({
            file_types = { "markdown", "markdown.mdx" },
        })

        vim.keymap.set("n", "<leader>mv", "<cmd>RenderMarkdown buf_toggle<CR>", { desc = "Toggle markdown view" })
    end,
}
