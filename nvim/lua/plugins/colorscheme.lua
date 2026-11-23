return {

    plugin = {
        src = "https://github.com/webhooked/kanso.nvim",
    },

    config = function()
        require("kanso").setup({ italics = false })
        require("theme").apply()
    end,
}
