-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Remove default LazyVim keymaps if needed
-- vim.keymap.del("n", "<leader>n")

-- Remove LazyVim's <leader>x group (diagnostics/quickfix) so our close buffer works
pcall(vim.keymap.del, "n", "<leader>xx")
pcall(vim.keymap.del, "n", "<leader>xX")
pcall(vim.keymap.del, "n", "<leader>xq")
pcall(vim.keymap.del, "n", "<leader>xQ")

-- Remove LazyVim's terminal keymaps
pcall(vim.keymap.del, "n", "<leader>ft")
pcall(vim.keymap.del, "n", "<leader>fT")
pcall(vim.keymap.del, "n", "<c-/>")
pcall(vim.keymap.del, "n", "<c-_>")
pcall(vim.keymap.del, "t", "<c-/>")
pcall(vim.keymap.del, "t", "<c-_>")
pcall(vim.keymap.del, "t", "<esc><esc>")

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
-- Formatting (Conform)
-- ========================================================================
-- LazyVim uses <leader>cf for format by default
-- Using <leader>fm for consistency with your previous setup
map({ "n", "v" }, "<leader>fm", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format file" })

-- ========================================================================
-- Buffer Navigation
-- ========================================================================
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Goto next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Goto prev buffer" })
map("n", "<C-]>", "<cmd>bnext<CR>", { desc = "Goto next buffer" })
map("n", "<leader>x", "<cmd>bd<cr>", { desc = "Close buffer", nowait = true })

-- ========================================================================
-- Comments
-- ========================================================================
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- ========================================================================
-- File Explorer (nvim-tree)
-- ========================================================================
map("n", "<leader>e", function()
  local api = require("nvim-tree.api")
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_ft = vim.bo[current_buf].filetype

  if buf_ft == "NvimTree" then
    -- If cursor is in nvim-tree, go back to previous window
    vim.cmd("wincmd p")
  else
    -- If cursor is not in nvim-tree, focus nvim-tree (open if not open)
    local nvim_tree_open = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "NvimTree" then
        nvim_tree_open = true
        vim.api.nvim_set_current_win(win)
        break
      end
    end

    if not nvim_tree_open then
      api.tree.open()
    end
  end
end, { desc = "Toggle nvim-tree focus" })
map("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle nvim-tree" })

-- ========================================================================
-- Snacks Picker (LazyVim's built-in picker)
-- ========================================================================
map("n", "<leader>fw", function()
  Snacks.picker.grep()
end, { desc = "Live grep" })
map("v", "<leader>fw", function()
  -- Get the current visual selection (before exiting visual mode)
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("v"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("."))

  -- Ensure start is before end
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end

  local lines = vim.fn.getline(start_row, end_row)

  if #lines == 0 then
    return
  end

  -- Handle single line selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    -- Handle multi-line selection
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end

  local selected_text = table.concat(lines, "\n")

  -- Exit visual mode first to clear the selection
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

  -- Search for the selected text globally with a fresh picker instance
  vim.schedule(function()
    Snacks.picker.grep({ search = selected_text })
  end)
end, { desc = "Search selected text globally" })
map("n", "<leader>fb", function()
  Snacks.picker.buffers()
end, { desc = "Find buffers" })
map("n", "<leader>fh", function()
  Snacks.picker.help()
end, { desc = "Help page" })
map("n", "<leader>ma", function()
  Snacks.picker.marks()
end, { desc = "Find marks" })
map("n", "<leader>fo", function()
  Snacks.picker.recent()
end, { desc = "Find oldfiles" })
map("n", "<leader>fz", function()
  Snacks.picker.grep_buffers()
end, { desc = "Find in current buffer" })
map("n", "<leader>cm", function()
  Snacks.picker.git_log()
end, { desc = "Git commits" })
map("n", "<leader>gt", function()
  Snacks.picker.git_status()
end, { desc = "Git status" })
map("n", "<leader>ff", function()
  Snacks.picker.files()
end, { desc = "Find files" })
map("n", "<leader>fa", function()
  local root = vim.fs.root(0, { ".git" })
  Snacks.picker.files({ cwd = root, hidden = true, no_ignore = true })
end, { desc = "Find all files from git root" })

-- LSP Symbol Search
-- ========================================================================
-- ========================================================================
map("n", "gs", function()
  Snacks.picker.lsp_symbols()
end, { desc = "Find symbols in document" })
map("n", "gS", function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = "Find symbols in workspace" })
map("n", "<leader>fr", function()
  Snacks.picker.lsp_references()
end, { desc = "Find references" })



-- ========================================================================
-- Better Copy/Paste
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
-- LSP Mappings
-- ========================================================================
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", { desc = "Go to definition" })
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", { desc = "Go to declaration" })
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "Go to references" })
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", { desc = "Go to implementation" })
map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })
map("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", { desc = "Hover documentation" })
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next diagnostic" })
map("n", "<leader>do", function()
  Snacks.picker.diagnostics_buffer()
end, { desc = "Open diagnostic float" })
map("n", "<leader>dl", function()
  Snacks.picker.diagnostics()
end, { desc = "List all diagnostics" })
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })

-- ========================================================================
-- Git (Gitsigns & git-blame)
-- ========================================================================
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview git hunk" })
map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Toggle git blame" })
map("n", "<leader>gB", "<cmd>GitBlameOpenCommitURL<cr>", { desc = "Open commit URL" })
map("n", "<leader>gc", "<cmd>GitBlameCopySHA<cr>", { desc = "Copy commit SHA" })
map("n", "[c", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Previous git hunk" })
map("n", "]c", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next git hunk" })

-- ========================================================================
-- LazyGit (if installed)
-- ========================================================================
map("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "Open LazyGit" })

-- ========================================================================
-- UFO Folding
-- ========================================================================
map("n", "zR", function()
  require("ufo").openAllFolds()
end, { desc = "Open all folds" })
map("n", "zM", function()
  require("ufo").closeAllFolds()
end, { desc = "Close all folds" })
map("n", "zr", function()
  require("ufo").openFoldsExceptKinds()
end, { desc = "Fold less" })
map("n", "zm", function()
  require("ufo").closeFoldsWith()
end, { desc = "Fold more" })
map("n", "zp", function()
  require("ufo").peekFoldedLinesUnderCursor()
end, { desc = "Peek fold" })

-- ========================================================================
-- Markdown Preview (Markview)
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
map("n", "<leader>um", "<cmd>Mason<cr>", { desc = "Mason (LSP installer)" })

-- ========================================================================

-- ========================================================================
-- Triforce (Profile Viewer)
-- ========================================================================
map("n", "<leader>tp", function()
  require("triforce").show_profile()
end, { desc = "Open triforce profile" })

-- ========================================================================
-- OpenCode (AI Assistant)
-- ========================================================================
map({ "n", "t" }, "<leader>oo", function()
  require("opencode").toggle()
end, { desc = "OpenCode toggle" })

map({ "n", "x" }, "<leader>oa", function()
  local oc = require("opencode")
  oc.show()
  oc.ask("@this: ", { submit = false })
end, { desc = "OpenCode ask" })

map({ "n", "x" }, "<leader>os", function()
  local oc = require("opencode")
  oc.show()
  oc.select()
end, { desc = "OpenCode select action" })

map("n", "<leader>on", function()
  require("opencode").command("session.new")
end, { desc = "OpenCode new session" })

map("n", "<leader>ol", function()
  require("opencode").command("session.list")
end, { desc = "OpenCode list sessions" })

map("n", "<leader>oi", function()
  require("opencode").command("session.interrupt")
end, { desc = "OpenCode interrupt" })

map("n", "<leader>oc", function()
  require("opencode").command("session.compact")
end, { desc = "OpenCode compact session" })

map("n", "<leader>ou", function()
  require("opencode").command("session.undo")
end, { desc = "OpenCode undo" })

map("n", "<leader>or", function()
  require("opencode").command("session.redo")
end, { desc = "OpenCode redo" })

map("n", "<leader>oS", function()
  require("opencode").command("session.share")
end, { desc = "OpenCode share session" })

map("n", "<leader>og", function()
  require("opencode").command("agent.cycle")
end, { desc = "OpenCode cycle agent" })
