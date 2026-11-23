-- Read on load, so set before vim.pack.add
vim.g.matchup_matchparen_deferred = 1
vim.g.matchup_matchparen_hi_surround_always = 1
vim.g.matchup_matchparen_deferred_hide_delay = 100
-- 0 runs the full search on every CursorMoved and stalls held j/k
vim.g.matchup_matchparen_deferred_show_delay = 50
-- Must be a dict; {} becomes a list and errors
vim.g.matchup_matchparen_offscreen = vim.empty_dict()

return {

    plugin = {
        src = "https://github.com/andymass/vim-matchup",
    },

    config = function()
        -- Also highlight the enclosing { }, not just the nearest pair
        local shown = {}

        local function clear(win)
            local current = shown[win]
            if current then
                pcall(vim.fn.matchdelete, current.id, win)
                shown[win] = nil
            end
        end

        local function enclosing_braces()
            local ok, node = pcall(vim.treesitter.get_node)
            if not ok or node == nil then
                return
            end

            while node do
                local count = node:child_count()
                if count >= 2 then
                    local open, close = node:child(0), node:child(count - 1)
                    if open:type() == "{" and close:type() == "}" then
                        return open, close
                    end
                end
                node = node:parent()
            end
        end

        local function update()
            local win = vim.api.nvim_get_current_win()

            if vim.bo.buftype ~= "" then
                return clear(win)
            end

            local open, close = enclosing_braces()
            if open == nil then
                return clear(win)
            end

            local open_row, open_col = open:range()
            local close_row, close_col = close:range()

            local cursor = vim.api.nvim_win_get_cursor(win)
            local row, col = cursor[1] - 1, cursor[2]
            if (row == open_row and col == open_col) or (row == close_row and col == close_col) then
                return clear(win)
            end

            local pair = ("%d:%d:%d:%d"):format(open_row, open_col, close_row, close_col)
            if shown[win] and shown[win].pair == pair then
                return
            end

            clear(win)
            shown[win] = {
                pair = pair,
                id = vim.fn.matchaddpos("MatchParen", {
                    { open_row + 1, open_col + 1 },
                    { close_row + 1, close_col + 1 },
                }, 10),
            }
        end

        local group = vim.api.nvim_create_augroup("EnclosingBrace", { clear = true })
        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "TextChanged", "TextChangedI", "BufWinEnter" }, {
            group = group,
            callback = update,
        })
        vim.api.nvim_create_autocmd("WinLeave", {
            group = group,
            callback = function() clear(vim.api.nvim_get_current_win()) end,
        })
        vim.api.nvim_create_autocmd("WinClosed", {
            group = group,
            callback = function(args) shown[tonumber(args.match)] = nil end,
        })
    end,
}
