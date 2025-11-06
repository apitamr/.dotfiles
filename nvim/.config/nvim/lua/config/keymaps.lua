-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- Remove default LazyVim keymaps if needed
-- vim.keymap.del("n", "<leader>n")

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
map("n", "<leader>x", function()
  local buf = vim.api.nvim_get_current_buf()
  vim.cmd("bnext")
  vim.api.nvim_buf_delete(buf, { force = false })
end, { desc = "Close buffer" })

-- ========================================================================
-- Comments
-- ========================================================================
map("n", "<leader>/", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "Toggle comment", remap = true })

-- ========================================================================
-- File Explorer
-- ========================================================================
map("n", "<leader>e", function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buf_ft = vim.bo[current_buf].filetype

  if buf_ft == "neo-tree" then
    -- If cursor is in neo-tree, go back to previous window
    vim.cmd("wincmd p")
  else
    -- If cursor is not in neo-tree, focus neo-tree (open if not open)
    local neo_tree_open = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "neo-tree" then
        neo_tree_open = true
        vim.api.nvim_set_current_win(win)
        break
      end
    end

    if not neo_tree_open then
      vim.cmd("Neotree show")
      -- After opening, focus neo-tree
      vim.defer_fn(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == "neo-tree" then
            vim.api.nvim_set_current_win(win)
            break
          end
        end
      end, 50)
    end
  end
end, { desc = "Toggle neo-tree focus" })
map("n", "<C-n>", "<cmd>Neotree toggle<cr>", { desc = "Toggle neo-tree" })
map("n", "<leader>E", "<cmd>Oil --float<cr>", { desc = "Toggle oil (float)" })

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
-- Terminal
-- ========================================================================
map("t", "<Esc><Esc>", "<C-\\><C-N>", { desc = "Escape terminal mode" })
map("t", "<C-q>", "<C-\\><C-N>:bd!<CR>", { desc = "Close terminal" })

-- Toggle horizontal terminal
map("n", "<leader>h", function()
  Snacks.terminal(nil, { win = { position = "bottom", height = 0.3 } })
end, { desc = "Toggle horizontal term" })

-- ========================================================================
-- Better Copy/Paste
-- ========================================================================
map("v", "p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
map({ "n", "v" }, "<leader>pp", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

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
-- Copilot
-- ========================================================================
map("i", "<C-J>", 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false,
  silent = true,
  desc = "Copilot Accept",
})
map("i", "<M-]>", "<Plug>(copilot-next)", { silent = true, desc = "Copilot Next" })
map("i", "<M-[>", "<Plug>(copilot-previous)", { silent = true, desc = "Copilot Previous" })
map("i", "<C-\\>", "<Plug>(copilot-dismiss)", { silent = true, desc = "Copilot Dismiss" })

-- ========================================================================
-- CodeCompanion (AI Assistant) - DISABLED
-- ========================================================================
-- map({ "n", "v" }, "<leader>aa", function()
--   require("codecompanion").toggle()
-- end, { desc = "AI Toggle Chat" })
-- map({ "n", "v" }, "<leader>ap", "<cmd>CodeCompanionActions<cr>", { desc = "AI Action Palette" })
-- map("v", "<leader>aA", "<cmd>CodeCompanionChat Add<cr>", { desc = "AI Add to Chat" })
-- map("n", "<leader>ao", "<cmd>CodeCompanionChat<cr>", { desc = "AI Open Chat" })
-- map({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI Inline Assistant" })
-- map("n", "<leader>ac", "<cmd>CodeCompanionCmd<cr>", { desc = "AI Generate Command" })
-- map("n", "<leader>aq", function()
--   local input = vim.fn.input("Quick AI Prompt: ")
--   if input ~= "" then
--     require("codecompanion").prompt(input)
--   end
-- end, { desc = "AI Quick Prompt" })
-- vim.cmd([[cab cc CodeCompanion]])
