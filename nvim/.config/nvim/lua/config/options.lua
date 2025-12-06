-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable netrw (vim's built-in file explorer) to prevent glitches
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.autoformat = false
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 120

vim.opt.relativenumber = true

-- Automatically change directory to the file being edited
vim.opt.autochdir = false

-- Disable LazyVim's root detection and use cwd instead
vim.g.root_spec = { "cwd" }

-- Add window borders
vim.opt.fillchars:append({
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vert = "│",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
})

-- Timeout settings
vim.opt.timeoutlen = 300  -- faster which-key popup
vim.opt.ttimeoutlen = 0

-- Disable auto comment continuation on new line
vim.opt.formatoptions:remove({ "c", "r", "o" })
