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
pcall(vim.keymap.del, "n", "<leader>fe")
pcall(vim.keymap.del, "n", "<leader>fE")

-- ========================================================================
-- Window Navigation
-- ========================================================================
map("n", "<C-h>", "<C-w>h", { desc = "Switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Switch window up" })
map("n", "<leader>wd", function()
  local buf = vim.api.nvim_get_current_buf()
  local wins = vim.tbl_filter(function(w)
    return vim.api.nvim_win_get_config(w).relative == ""
  end, vim.api.nvim_list_wins())
  if #wins > 1 then
    vim.cmd("close")
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  else
    require("oil").open(vim.fn.getcwd())
    vim.schedule(function()
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end)
  end
end, { desc = "Close Window" })
map("n", "<leader>wq", function()
  -- Close all non-Oil windows and delete their buffers
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= "oil" then
      if not pcall(vim.api.nvim_win_close, win, false) then
        vim.api.nvim_set_current_win(win)
        require("oil").open(vim.fn.getcwd())
      end
    end
  end
  -- Delete all non-Oil buffers
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].filetype ~= "oil" then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
end, { desc = "Close all windows" })

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
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New Buffer" })
map("n", "<leader>bd", function()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_get_current_buf()
  local is_floating = vim.api.nvim_win_get_config(current_win).relative ~= ""
  local is_oil = vim.bo[current_buf].filetype == "oil"

  -- If in floating Oil, close the float first
  if is_floating and is_oil then
    vim.api.nvim_win_close(current_win, true)
  end

  -- Close all non-Oil buffers (including existing Oil buffers to get fresh one)
  local bufs = vim.api.nvim_list_bufs()
  for _, buf in ipairs(bufs) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      local name = vim.api.nvim_buf_get_name(buf)
      local ft = vim.bo[buf].filetype
      if ft ~= "oil" and not name:match("^oil://") then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end

  -- Always open fresh Oil
  vim.schedule(function()
    require("oil").open(vim.fn.getcwd())
  end)
end, { desc = "Close All Buffers" })
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
end, { desc = "Close Buffer", nowait = true })

-- ========================================================================
-- Comments
-- ========================================================================
map("n", "<leader>/", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle Comment", remap = true })

-- ========================================================================
-- Oil (File Explorer)
-- ========================================================================
map("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
map("n", "<leader>o", function()
  if vim.bo.filetype ~= "oil" then
    require("oil").open_float()
  end
end, { desc = "Oil Float" })

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
end, { desc = "Outline" })
map("n", "<C-n>", "<cmd>Outline<cr>", { desc = "Toggle Outline" })

-- ========================================================================
-- Snacks Picker
-- ========================================================================
map("n", "<leader>fw", function()
  Snacks.picker.grep()
end, { desc = "Grep" })
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
end, { desc = "Grep Selection" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help" })
map("n", "<leader>fo", function() Snacks.picker.recent() end, { desc = "Recent Files" })
map("n", "<leader>fO", function()
  vim.v.oldfiles = {}
  vim.notify("Oldfiles cleared", vim.log.levels.INFO)
end, { desc = "Clear Recent" })
map("n", "<leader>fz", function() Snacks.picker.grep_buffers() end, { desc = "Grep Buffer" })
map("n", "<leader>fr", function() Snacks.picker.lsp_references() end, { desc = "References" })
map("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Commits" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Status" })
map("n", "<leader>ma", function() Snacks.picker.marks() end, { desc = "Marks" })

-- ========================================================================
-- File Finder
-- ========================================================================
map("n", "<leader>ff", function()
  local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  Snacks.picker.files({ hidden = true, ignored = true, cwd = git_root or nil, exclude = { "node_modules" } })
end, { desc = "Files" })
map("n", "<leader>fa", function() Snacks.picker.files({ hidden = true, ignored = true }) end, { desc = "All Files" })

-- ========================================================================
-- LSP Symbol Search
-- ========================================================================
map("n", "gss", function() Snacks.picker.lsp_symbols() end, { desc = "Document Symbols" })
map("n", "gsS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace Symbols" })

-- ========================================================================
-- Copy/Paste
-- ========================================================================
map("v", "p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to Clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank Line to Clipboard" })
map({ "n", "v" }, "<leader>pp", '"+p', { desc = "Paste from Clipboard" })
map({ "n", "v" }, "<leader>D", '"_d', { desc = "Delete (No Yank)" })

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
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", { desc = "Previous diagnostic" })
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", { desc = "Next diagnostic" })
map("n", "<leader>do", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer" })
map("n", "<leader>dl", function() Snacks.picker.diagnostics() end, { desc = "All" })
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "Loclist" })

-- ========================================================================
-- Git
-- ========================================================================
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview Hunk" })
map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Blame" })
map("n", "<leader>gB", "<cmd>GitBlameOpenCommitURL<cr>", { desc = "Blame URL" })
map("n", "<leader>gC", "<cmd>GitBlameCopySHA<cr>", { desc = "Copy SHA" })
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "LazyGit" })
map("n", "<leader>gf", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" then
    Snacks.picker.git_log_file({ file = file })
  else
    vim.notify("No file in current buffer", vim.log.levels.WARN)
  end
end, { desc = "File History" })
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
map("n", "<leader>mt", "<cmd>Markview toggle<cr>", { desc = "Toggle Preview" })
map("n", "<leader>mp", "<cmd>Markview enable<cr>", { desc = "Enable Preview" })
map("n", "<leader>ms", "<cmd>Markview disable<cr>", { desc = "Disable Preview" })
map("n", "<leader>mh", "<cmd>Markview hybridToggle<cr>", { desc = "Hybrid Mode" })
map("n", "<leader>mv", "<cmd>Markview splitToggle<cr>", { desc = "Split View" })

-- ========================================================================
-- Miscellaneous
-- ========================================================================
map("n", "<leader>uu", "<cmd>Lazy update<cr>", { desc = "Update Plugins" })
map("n", "<leader>um", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer Keymaps" })

-- ========================================================================
-- Context
-- ========================================================================
map({ "n", "v" }, "<leader>ac", function() require("context").pick() end, { desc = "Context" })

-- ========================================================================
-- Terminal
-- ========================================================================
map("n", "<leader>h", function() Snacks.terminal() end, { desc = "Terminal" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
