-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Performance optimizations
vim.loader.enable() -- Enable byte-compiled lua caching

-- Reduce update frequency
vim.opt.updatetime = 300 -- Faster completion (default 4000ms)
vim.opt.redrawtime = 1500 -- Allow more time for syntax highlighting large files
vim.opt.synmaxcol = 300 -- Only highlight first 300 columns (improves performance on long lines)
vim.opt.lazyredraw = false -- Don't use lazyredraw with noice/similar plugins

-- Memory/history limits
vim.opt.history = 100 -- Reduce command history (default 10000)
vim.opt.undolevels = 500 -- Reduce undo levels (default 1000)
vim.opt.undoreload = 5000 -- Reduce undo lines for buffer reload (default 10000)

-- Disable providers for unused languages (major CPU/memory savings)
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

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
