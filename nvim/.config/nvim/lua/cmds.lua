-- Sent by tmux and after a Ghostty theme change
vim.api.nvim_create_autocmd("Signal", {
    group = vim.api.nvim_create_augroup("theme-reload", { clear = true }),
    pattern = "SIGUSR1",
    callback = function()
        vim.schedule(function() require("theme").reload() end)
    end,
})

vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("treesitter-update", { clear = true }),
    pattern = { "PackInstallPost", "PackUpdatePost" },
    callback = function() pcall(vim.cmd, "TSUpdate") end,
})

-- Wrapped NUL bytes (^@) split across rows and make the cursor jump
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("binary-nowrap", { clear = true }),
    desc = "Disable wrap for binary files",
    callback = function(args)
        local binary = false
        for _, line in ipairs(vim.api.nvim_buf_get_lines(args.buf, 0, 50, false)) do
            if line:find("\0", 1, true) then
                binary = true
                break
            end
        end
        -- vim.wo[0][0] is :setlocal; plain vim.wo would change the global too
        vim.wo[0][0].wrap = not binary and vim.go.wrap
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank() end,
})

-- Treat all JSON as JSONC so comments and trailing commas never show as errors
vim.filetype.add({
    extension = {
        json = "jsonc",
    },
})
vim.treesitter.language.register("json", "jsonc")
