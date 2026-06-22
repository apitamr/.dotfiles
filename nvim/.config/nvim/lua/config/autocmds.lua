-- Autocmds are automatically loaded on the VeryLazy event

local image = require("util.image")
local buffer = require("util.buffer")

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#23262c", bg = "NONE" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#23262c", bg = "NONE" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#23262c", bg = "NONE" })
    vim.api.nvim_set_hl(0, "LspFloat", { bg = "#1a1a1a" })
    vim.api.nvim_set_hl(0, "LspFloatBorder", { bg = "#1a1a1a", fg = "#5c5c5c" })
  end,
})

-- LSP float window styling (solid background, sizing, focus).
require("util.lsp").setup_floating_preview()

-- Reapply the colorscheme on SIGUSR1 (sent by a tmux hook on session switch),
-- which otherwise resets the transparent background to a solid one. Signal
-- fires in a fast context where :colorscheme is blocked, and the post-switch
-- event that resets the background lands shortly after, so defer past it.
vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = function()
    vim.defer_fn(function()
      vim.cmd.colorscheme("kanso")
    end, 200)
  end,
})

-- Disable auto comment continuation on new line
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Open Neo-tree (full window) when Neovim starts with no file arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.schedule(function()
        vim.cmd("Neotree position=current dir=" .. vim.fn.fnameescape(vim.fn.getcwd()))
      end)
    end
  end,
})

-- Open file from lazygit without splits (called by the lazygit edit command)
_G.LazygitEdit = buffer.lazygit_edit

-- Hide cursor when viewing image buffers (snacks.image)
image.setup_cursor_autohide()

-- Auto-delete empty unnamed buffers when leaving them
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(args)
    local buf = args.buf
    vim.defer_fn(function() buffer.cleanup_if_empty(buf) end, 100)
  end,
})
