-- Options are automatically loaded before lazy.nvim startup

-- Reduce update frequency
vim.opt.updatetime = 250
vim.opt.redrawtime = 1500
vim.opt.synmaxcol = 300

-- Memory/history limits
vim.opt.history = 100
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
vim.opt.maxmempattern = 1000
vim.opt.shada = "!,'50,<50,s10,h"

-- Disable providers for unused languages
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

vim.g.autoformat = false

-- Editor behavior
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 120

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

-- Faster key sequences
vim.opt.ttimeoutlen = 0

-- Hide cmdline when not in use; native nvim shows it on demand
vim.opt.cmdheight = 0

-- Route partial keystrokes (showcmd) to statusline
vim.opt.showcmdloc = "statusline"
