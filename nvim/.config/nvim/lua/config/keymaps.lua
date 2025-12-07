-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-- Remove LazyVim's default keymaps
pcall(vim.keymap.del, "n", "<leader>xx")
pcall(vim.keymap.del, "n", "<leader>xX")
pcall(vim.keymap.del, "n", "<leader>xq")
pcall(vim.keymap.del, "n", "<leader>xQ")
pcall(vim.keymap.del, "n", "<leader>ft")
pcall(vim.keymap.del, "n", "<leader>fT")
pcall(vim.keymap.del, "n", "<c-/>")
pcall(vim.keymap.del, "n", "<c-_>")
pcall(vim.keymap.del, "t", "<c-/>")
pcall(vim.keymap.del, "t", "<c-_>")
pcall(vim.keymap.del, "t", "<esc><esc>")
pcall(vim.keymap.del, "n", "<leader>fe")
pcall(vim.keymap.del, "n", "<leader>fE")

-- ========================================================================
-- Window Navigation
-- ========================================================================
map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })

-- ========================================================================
-- General Editing
-- ========================================================================
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })

-- ========================================================================
-- Buffer Navigation
-- ========================================================================
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Goto next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Goto prev buffer" })
map("n", "<C-]>", "<cmd>bnext<CR>", { desc = "Goto next buffer" })
map("n", "<leader>x", function()
  -- Check if this is the last non-oil buffer
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  local non_oil_bufs = vim.tbl_filter(function(buf)
    return vim.bo[buf.bufnr].filetype ~= "oil"
  end, bufs)

  Snacks.bufdelete()

  -- If we just closed the last buffer, open Oil
  if #non_oil_bufs <= 1 then
    vim.schedule(function()
      require("oil").open()
    end)
  end
end, { desc = "Close buffer", nowait = true })

-- ========================================================================
-- Comments
-- ========================================================================
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- ========================================================================
-- Oil (File Explorer)
-- ========================================================================
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "<leader>o", "<cmd>Oil --float<cr>", { desc = "Open Oil (float)" })

-- ========================================================================
-- Outline
-- ========================================================================
map("n", "<leader>e", function()
  local outline = require("outline")
  if outline.is_open() then
    outline.focus_outline()
  else
    outline.open()
  end
end, { desc = "Focus Outline" })
map("n", "<C-n>", "<cmd>Outline<cr>", { desc = "Toggle Outline" })

-- ========================================================================
-- Snacks Picker
-- ========================================================================
map("n", "<leader>fw", function()
  Snacks.picker.grep()
end, { desc = "Live grep" })
map("v", "<leader>fw", function()
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("v"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("."))
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end
  local lines = vim.fn.getline(start_row, end_row)
  if #lines == 0 then
    return
  end
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end
  local selected_text = table.concat(lines, "\n")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  vim.schedule(function()
    Snacks.picker.grep({ search = selected_text })
  end)
end, { desc = "Search selected text" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Find buffers" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help page" })
map("n", "<leader>fo", function() Snacks.picker.recent() end, { desc = "Find oldfiles" })
map("n", "<leader>fO", function()
  vim.v.oldfiles = {}
  vim.notify("Oldfiles cleared", vim.log.levels.INFO)
end, { desc = "Clear oldfiles" })
map("n", "<leader>fz", function() Snacks.picker.grep_buffers() end, { desc = "Find in current buffer" })
map("n", "<leader>fr", function() Snacks.picker.lsp_references() end, { desc = "Find references" })
map("n", "<leader>cm", function() Snacks.picker.git_log() end, { desc = "Git commits" })
map("n", "<leader>gt", function() Snacks.picker.git_status() end, { desc = "Git status" })
map("n", "<leader>ma", function() Snacks.picker.marks() end, { desc = "Find marks" })

-- ========================================================================
-- FFF File Finder
-- ========================================================================
map("n", "<leader>ff", function() require("fff").find_files() end, { desc = "Find files" })
map("n", "<leader>fF", function() require("fff").find_in_git_root() end, { desc = "Find files (git root)" })
map("n", "<leader>fa", function() require("fff").find_in_git_root() end, { desc = "Find all files (git root)" })

-- ========================================================================
-- LSP Symbol Search
-- ========================================================================
map("n", "gs", function() Snacks.picker.lsp_symbols() end, { desc = "Find symbols in document" })
map("n", "gS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Find symbols in workspace" })

-- ========================================================================
-- Copy/Paste
-- ========================================================================
map("v", "p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>pp", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete without yanking" })

-- ========================================================================
-- Text Editing
-- ========================================================================
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- ========================================================================
-- LSP
-- ========================================================================
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Go to declaration" })
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Go to references" })
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Go to implementation" })
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next diagnostic" })
map("n", "<leader>do", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer diagnostics" })
map("n", "<leader>dl", function() Snacks.picker.diagnostics() end, { desc = "All diagnostics" })
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })

-- ========================================================================
-- Git
-- ========================================================================
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview git hunk" })
map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle git blame" })
map("n", "<leader>gB", "<cmd>GitBlameOpenCommitURL<cr>", { desc = "Open commit URL" })
map("n", "<leader>gc", "<cmd>GitBlameCopySHA<cr>", { desc = "Copy commit SHA" })
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "LazyGit" })
map("n", "[c", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous git hunk" })
map("n", "]c", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next git hunk" })

-- ========================================================================
-- UFO Folding
-- ========================================================================
map("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
map("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
map("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { desc = "Fold less" })
map("n", "zm", function() require("ufo").closeFoldsWith() end, { desc = "Fold more" })
map("n", "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, { desc = "Peek fold" })

-- ========================================================================
-- Markdown (Markview)
-- ========================================================================
map("n", "<leader>mt", "<cmd>Markview toggle<cr>", { desc = "Toggle markdown preview" })
map("n", "<leader>mp", "<cmd>Markview enable<cr>", { desc = "Enable markdown preview" })
map("n", "<leader>ms", "<cmd>Markview disable<cr>", { desc = "Disable markdown preview" })
map("n", "<leader>mh", "<cmd>Markview hybridToggle<cr>", { desc = "Toggle hybrid mode" })
map("n", "<leader>mv", "<cmd>Markview splitToggle<cr>", { desc = "Toggle split view" })

-- ========================================================================
-- Miscellaneous
-- ========================================================================
map("n", "<leader>uu", "<cmd>Lazy update<cr>", { desc = "Update plugins" })
map("n", "<leader>um", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer keymaps" })

-- ========================================================================
-- Triforce
-- ========================================================================
map("n", "<leader>tp", function() require("triforce").show_profile() end, { desc = "Open profile" })

-- ========================================================================
-- Krust (Rust Diagnostics)
-- ========================================================================
map("n", "<leader>k", function() require("krust").render() end, { desc = "Rust diagnostics" })

-- ========================================================================
-- Context
-- ========================================================================
map({ "n", "v" }, "<leader>ac", function() require("context").pick() end, { desc = "Context picker" })
