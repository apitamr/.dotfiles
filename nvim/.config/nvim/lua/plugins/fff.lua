-- Registered at require time: config() runs after the install event has fired
vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("fff-binary", { clear = true }),
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name ~= "fff" or (kind ~= "install" and kind ~= "update") then
            return
        end
        if not ev.data.active then
            vim.cmd.packadd("fff")
        end
        require("fff.download").download_or_build_binary()
    end,
})

return {

    plugin = {
        src = "https://github.com/dmtrKovalenko/fff",
    },

    config = function()
        require("fff").setup({
            prompt = "\u{F105} ",
            prompt_vim_mode = true,
            mappings = {
                i = { ["jj"] = "<Esc>" },
            },
            layout = {
                border = "single",
            },
            -- Default `Title` has no background, leaving a see-through gap in the border
            hl = { title = "FloatTitle" },
            keymaps = {
                -- Replaces the defaults, so they're repeated here
                move_down = { "<Down>", "<C-n>", "<C-j>" },
                move_up = { "<Up>", "<C-p>", "<C-k>" },
            },
        })

        local map = function(lhs, fn, desc) vim.keymap.set("n", lhs, fn, { desc = desc }) end

        map("<leader>ff", function() require("fff").find_files() end, "Find files")
        map("<leader>fw", function() require("fff").live_grep() end, "Live grep")
        map("<leader>fc", function() require("fff").live_grep_under_cursor() end, "Grep word under cursor")
    end,
}
