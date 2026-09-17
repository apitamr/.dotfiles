local map = vim.keymap.set

-- Wrapped rows without a count, real lines with one
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up" })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down" })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up" })

-- At the edge of Neovim's splits, hand the move to tmux (see tmux.conf)
local pane = {
    h = { key = "L", name = "left" },
    j = { key = "D", name = "down" },
    k = { key = "U", name = "up" },
    l = { key = "R", name = "right" },
}

local function navigate(dir)
    return function()
        local from = vim.api.nvim_get_current_win()
        vim.cmd.wincmd(dir)

        if vim.api.nvim_get_current_win() == from and vim.env.TMUX then
            vim.system({ "tmux", "select-pane", "-" .. pane[dir].key })
        end
    end
end

for dir, to in pairs(pane) do
    map("n", "<C-" .. dir .. ">", navigate(dir), { desc = "Window/pane " .. to.name })
    map("t", "<C-" .. dir .. ">", function()
        vim.cmd("stopinsert")
        navigate(dir)()
    end, { desc = "Window/pane " .. to.name })
end

map("t", "<C-x>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Alt needs Ghostty's macos-option-as-alt
map("n", "<M-h>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<M-l>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
map("n", "<M-j>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<M-k>", "<cmd>resize +2<CR>", { desc = "Increase window height" })

map("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Split vertically" })
map("n", "<leader>sh", "<cmd>split<CR>", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
map("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })

map("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit Neovim" })

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })
