-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable LazyVim's root detection autocmd
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_root")
  end,
})

-- Set border highlights for kanso theme
local function set_border_colors()
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#23262c", bg = "NONE" })
  vim.api.nvim_set_hl(0, "VertSplit", { fg = "#23262c", bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#23262c", bg = "NONE" })
end

-- Set on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_border_colors,
})

-- Set after UI enters (to override lazy-loaded plugins)
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.defer_fn(set_border_colors, 100)
  end,
})
