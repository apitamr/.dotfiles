-- Keymaps are automatically loaded on the VeryLazy event
-- Only customizations here; LazyVim defaults are left intact.

local map = vim.keymap.set
local tree = require("util.tree")
local image = require("util.image")
local picker = require("util.picker")

-- Remove LazyVim defaults we don't use
local del = { "<leader>xx", "<leader>xX", "<leader>xq", "<leader>xQ", "<leader>ft", "<leader>fT",
  "<c-/>", "<c-_>", "<leader>fe", "<leader>fE", "<leader>-", "<leader>wd" }
for _, k in ipairs(del) do pcall(vim.keymap.del, { "n", "t" }, k) end

-- Disable mark-setting (m{a-z}/m{A-Z}); use jumps/search instead
map({ "n", "x" }, "m", "<Nop>", { desc = "Disabled (was: set mark)" })

-- General
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "Copy whole file" })
map("n", ";", ":", { desc = "Command mode" })
map("i", "jj", "<ESC>", { desc = "Exit insert mode" })

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })
map("n", "n", "nzzzv", { desc = "Next search centered" })
map("n", "N", "Nzzzv", { desc = "Prev search centered" })

-- Move lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down", silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up", silent = true })
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Indent
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Copy/Paste
map("v", "p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })
map({ "n", "v" }, "<leader>pp", '"+p', { desc = "Paste from clipboard" })
map({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete (no yank)" })

-- Comments
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- Buffers
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<S-h>", image.switch_then_resend("bprevious"), { desc = "Prev buffer (resend image)" })
map("n", "<S-l>", image.switch_then_resend("bnext"), { desc = "Next buffer (resend image)" })
map("n", "<leader>x", tree.close_current_buffer, { desc = "Close buffer", nowait = true })
map("n", "<leader>bd", tree.close_all_buffers, { desc = "Close all buffers", nowait = true })

-- Neo-tree
map("n", "-",         function() tree.toggle("left") end,  { desc = "Toggle file tree" })
map("n", "<leader>e", function() tree.toggle("left") end,  { desc = "Toggle sidebar tree" })
map("n", "<leader>o", function() tree.toggle("float") end, { desc = "File tree (float)" })

-- Picker (Snacks) — only non-default variants
map("v", "<leader>fw", picker.grep_selection, { desc = "Grep selection" })
map("n", "<leader>fo", function() Snacks.picker.recent() end, { desc = "Recent files" })
map("n", "<leader>fO", picker.clear_recent, { desc = "Clear recent" })
map("n", "<leader>fz", function() Snacks.picker.grep_buffers() end, { desc = "Grep buffer" })
map("n", "gss", function() Snacks.picker.lsp_symbols() end, { desc = "Document symbols" })
map("n", "gsS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace symbols" })

-- Tools (Snacks)
map("n", "<leader>h", function() Snacks.terminal(nil, { win = { position = "bottom", relative = "win" } }) end, { desc = "Terminal" })
map("n", "<leader>th", function() Snacks.terminal.open(nil, { win = { position = "bottom", relative = "win" } }) end, { desc = "New terminal (horizontal)" })
map("n", "<leader>tv", function() Snacks.terminal.open(nil, { win = { position = "right" } }) end, { desc = "New terminal (vertical)" })

-- LSP (custom: Snacks pickers + custom borders)
map("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References" })
map("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "Implementation" })
map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Type definition" })
-- LSP floats: border/size handled by open_floating_preview override in util/lsp.lua
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })

-- Diagnostics (extras over LazyVim defaults)
map("n", "<leader>do", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer diagnostics" })
map("n", "<leader>dl", function() Snacks.picker.diagnostics() end, { desc = "All diagnostics" })
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "Loclist" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Git (custom: visual-range hunks, blame plugin, history)
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
map("v", "<leader>ghs", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
map("v", "<leader>ghr", function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
map("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Commits" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Status" })
map("n", "<leader>gf", picker.git_file_history, { desc = "File history" })

-- Window resize
map("n", "<A-k>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<A-j>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- Quickfix (extras over LazyVim defaults)
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })

-- Misc
map("n", "<leader>ue", image.toggle_source, { desc = "Toggle image/source" })
map("n", "<leader>ir", image.resend_all, { desc = "Re-send images to terminal" })
map("n", "<leader>fm", function() Snacks.picker.marks() end, { desc = "Marks" })
map("n", "<leader>fM", picker.clear_marks, { desc = "Clear all marks" })
map("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer keymaps" })
