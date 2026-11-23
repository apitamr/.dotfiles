return {

    plugin = {
        src = "https://github.com/folke/sidekick.nvim",
    },

    config = function()
        require("sidekick").setup({
            -- Next Edit Suggestions need Copilot, which isn't set up
            nes = { enabled = false },
            copilot = { status = { enabled = false } },

            cli = {
                win = {
                    keys = {
                        -- keymaps.lua's terminal <C-hjkl> also hand off to tmux at the edge
                        nav_left = false,
                        nav_down = false,
                        nav_up = false,
                        nav_right = false,
                    },
                },
                picker = "snacks",
            },
        })

        local cli = require("sidekick.cli")
        local map = function(mode, lhs, fn, desc) vim.keymap.set(mode, lhs, fn, { desc = desc }) end

        map({ "n", "t", "i", "x" }, "<C-.>", function() cli.focus() end, "Sidekick focus")
        map("n", "<leader>aa", function() cli.toggle() end, "Sidekick toggle CLI")
        map("n", "<leader>ac", function() cli.toggle({ name = "claude", focus = true }) end, "Sidekick toggle Claude")
        map("n", "<leader>as", function() cli.select({ filter = { installed = true } }) end, "Sidekick select CLI")
        map("n", "<leader>ad", function() cli.close() end, "Sidekick detach CLI session")
        map({ "n", "x" }, "<leader>at", function() cli.send({ msg = "{this}" }) end, "Sidekick send this")
        map("n", "<leader>af", function() cli.send({ msg = "{file}" }) end, "Sidekick send file")
        map("x", "<leader>av", function() cli.send({ msg = "{selection}" }) end, "Sidekick send selection")
        map({ "n", "x" }, "<leader>ap", function() cli.prompt() end, "Sidekick select prompt")

        vim.api.nvim_create_autocmd("VimResized", {
            group = vim.api.nvim_create_augroup("sidekick-width", { clear = true }),
            callback = function()
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    if vim.w[win].sidekick_cli and vim.api.nvim_win_get_config(win).relative == "" then
                        vim.wo[win].winfixwidth = true
                        pcall(vim.api.nvim_win_set_width, win, math.min(80, math.floor(vim.o.columns * 0.5)))
                    end
                end
            end,
        })
    end,
}
