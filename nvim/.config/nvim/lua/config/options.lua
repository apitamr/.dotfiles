-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Reduce update frequency
vim.opt.updatetime = 250
vim.opt.redrawtime = 1500
vim.opt.synmaxcol = 300
vim.opt.lazyredraw = false

-- Memory/history limits
vim.opt.history = 100
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.maxmempattern = 1000
vim.opt.shada = "!,'50,<50,s10,h"

-- Persistent undo (survive restarts)
vim.opt.undofile = true

-- Disable providers for unused languages
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.autoformat = false

-- Editor behavior
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 120
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

-- Scroll context
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Splits open in natural direction
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "screen"

-- Automatically change directory to the file being edited
vim.opt.autochdir = false

-- Disable LazyVim's root detection and use cwd instead
vim.g.root_spec = { "cwd" }

-- Window borders
vim.opt.fillchars:append({
  horiz = "─",
  horizup = "┴",
  horizdown = "┬",
  vert = "│",
  vertleft = "┤",
  vertright = "├",
  verthoriz = "┼",
  diff = "╱",
  eob = " ",
})

-- Timeout settings
vim.opt.timeoutlen = 300
vim.opt.ttimeoutlen = 0

-- Disable auto comment continuation on new line
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- Grep program (use ripgrep if available)
if vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m"
end

-- Shorter messages, don't show intro
vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- Allow cursor to move where there is no text in visual block mode
vim.opt.virtualedit = "block"

-- Better completion experience
vim.opt.completeopt = "menu,menuone,noselect"
