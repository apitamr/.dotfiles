-- Keymaps are automatically loaded on the VeryLazy event

local map = vim.keymap.set

-- Remove LazyVim defaults we don't use
local del = { "<leader>xx", "<leader>xX", "<leader>xq", "<leader>xQ", "<leader>ft", "<leader>fT",
  "<c-/>", "<c-_>", "<leader>fe", "<leader>fE", "<leader>-" }
for _, k in ipairs(del) do pcall(vim.keymap.del, { "n", "t" }, k) end

-- General
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "Clear highlights" })
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<cmd>w<CR><Esc>", { desc = "Save file" })
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

-- Windows
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Height +" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Height -" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Width -" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Width +" })
map("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
map("n", "<leader>ws", "<C-w>s", { desc = "Horizontal split" })
map("n", "<leader>w=", "<C-w>=", { desc = "Equalize windows" })

map("n", "<leader>wd", function()
  local buf = vim.api.nvim_get_current_buf()
  local normal_wins = vim.tbl_filter(function(w)
    return vim.api.nvim_win_get_config(w).relative == ""
  end, vim.api.nvim_list_wins())
  if #normal_wins > 1 then
    vim.cmd("close")
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  else
    require("oil").open(vim.fn.getcwd())
    vim.schedule(function() pcall(vim.api.nvim_buf_delete, buf, { force = true }) end)
  end
end, { desc = "Close window" })

map("n", "<leader>wq", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype ~= "oil" then
      if not pcall(vim.api.nvim_win_close, win, false) then
        vim.api.nvim_set_current_win(win)
        require("oil").open(vim.fn.getcwd())
      end
    end
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].filetype ~= "oil" then
      pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end
  end
end, { desc = "Close all windows" })

-- Buffers
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })

map("n", "<leader>bd", function()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  if vim.api.nvim_win_get_config(win).relative ~= "" and vim.bo[buf].filetype == "oil" then
    vim.api.nvim_win_close(win, true)
  end
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].filetype ~= "oil" then
      pcall(vim.api.nvim_buf_delete, b, { force = true })
    end
  end
  vim.schedule(function() require("oil").open(vim.fn.getcwd()) end)
end, { desc = "Close all buffers" })

map("n", "<leader>x", function()
  local non_oil = vim.tbl_filter(function(b)
    return vim.bo[b.bufnr].filetype ~= "oil"
  end, vim.fn.getbufinfo({ buflisted = 1 }))
  Snacks.bufdelete()
  if #non_oil <= 1 then
    vim.schedule(function() require("oil").open() end)
  end
end, { desc = "Close buffer", nowait = true })

-- Oil
map("n", "-", "<cmd>Oil<cr>", { desc = "Parent directory" })
map("n", "<leader>o", function()
  if vim.bo.filetype ~= "oil" then require("oil").open_float() end
end, { desc = "Oil float" })

-- Picker (Snacks)
map("n", "<leader>fw", function() Snacks.picker.grep() end, { desc = "Grep" })
map("v", "<leader>fw", function()
  local _, sr, sc = unpack(vim.fn.getpos("v"))
  local _, er, ec = unpack(vim.fn.getpos("."))
  if sr > er or (sr == er and sc > ec) then sr, er, sc, ec = er, sr, ec, sc end
  local lines = vim.fn.getline(sr, er)
  if #lines == 0 then return end
  if #lines == 1 then lines[1] = lines[1]:sub(sc, ec)
  else lines[1] = lines[1]:sub(sc); lines[#lines] = lines[#lines]:sub(1, ec) end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  vim.schedule(function() Snacks.picker.grep({ search = table.concat(lines, "\n") }) end)
end, { desc = "Grep selection" })
map("n", "<leader>fa", function() Snacks.picker.files({ hidden = true, ignored = true }) end, { desc = "All files" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
map("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Help" })
map("n", "<leader>fo", function() Snacks.picker.recent() end, { desc = "Recent files" })
map("n", "<leader>fO", function() vim.v.oldfiles = {}; vim.notify("Oldfiles cleared") end, { desc = "Clear recent" })
map("n", "<leader>fz", function() Snacks.picker.grep_buffers() end, { desc = "Grep buffer" })
map("n", "<leader>fr", function() Snacks.picker.lsp_references() end, { desc = "References" })
map("n", "<leader>fk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
map("n", "<leader>fc", function() Snacks.picker.commands() end, { desc = "Commands" })
map("n", "<leader>fd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
map("n", "gss", function() Snacks.picker.lsp_symbols() end, { desc = "Document symbols" })
map("n", "gsS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace symbols" })

-- Tools (Snacks)
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "LazyGit" })
map("n", "<leader>h", function() Snacks.terminal() end, { desc = "Terminal" })

-- FFF (File Finder)
map("n", "<leader>ff", "<cmd>FFFFind<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>FFFScan<cr>", { desc = "Find in git root" })

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Type definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "LSP info" })

-- Diagnostics
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, { desc = "Next diagnostic" })
map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev error" })
map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })
map("n", "<leader>do", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer diagnostics" })
map("n", "<leader>dl", function() Snacks.picker.diagnostics() end, { desc = "All diagnostics" })
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "Loclist" })
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Git
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview hunk" })
map("n", "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage hunk" })
map("n", "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset hunk" })
map("n", "<leader>ghS", "<cmd>Gitsigns stage_buffer<cr>", { desc = "Stage buffer" })
map("n", "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo stage" })
map("n", "<leader>ghd", "<cmd>Gitsigns diffthis<cr>", { desc = "Diff this" })
map("v", "<leader>ghs", function() require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Stage hunk" })
map("v", "<leader>ghr", function() require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "Reset hunk" })
map("n", "<leader>gb", "<cmd>GitBlameToggle<cr>", { desc = "Blame" })
map("n", "<leader>gB", "<cmd>GitBlameOpenCommitURL<cr>", { desc = "Blame URL" })
map("n", "<leader>gC", "<cmd>GitBlameCopySHA<cr>", { desc = "Copy SHA" })
map("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "Commits" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Status" })
map("n", "<leader>gf", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" then Snacks.picker.git_log_file({ file = file })
  else vim.notify("No file in current buffer", vim.log.levels.WARN) end
end, { desc = "File history" })
map("n", "[c", "<cmd>Gitsigns prev_hunk<cr>", { desc = "Prev hunk" })
map("n", "]c", "<cmd>Gitsigns next_hunk<cr>", { desc = "Next hunk" })

-- UFO Folding
map("n", "zR", function() require("ufo").openAllFolds() end, { desc = "Open all folds" })
map("n", "zM", function() require("ufo").closeAllFolds() end, { desc = "Close all folds" })
map("n", "zr", function() require("ufo").openFoldsExceptKinds() end, { desc = "Fold less" })
map("n", "zm", function() require("ufo").closeFoldsWith() end, { desc = "Fold more" })
map("n", "zp", function() require("ufo").peekFoldedLinesUnderCursor() end, { desc = "Peek fold" })

-- Markdown (Markview)
map("n", "<leader>mt", "<cmd>Markview toggle<cr>", { desc = "Toggle preview" })
map("n", "<leader>mp", "<cmd>Markview enable<cr>", { desc = "Enable preview" })
map("n", "<leader>ms", "<cmd>Markview disable<cr>", { desc = "Disable preview" })
map("n", "<leader>mh", "<cmd>Markview hybridToggle<cr>", { desc = "Hybrid mode" })
map("n", "<leader>mv", "<cmd>Markview splitToggle<cr>", { desc = "Split view" })

-- AI (Sidekick)
map({ "n", "t", "i", "x" }, "<c-.>", function() require("sidekick.cli").toggle() end, { desc = "Sidekick toggle" })
map("n", "<leader>aa", function() require("sidekick.cli").toggle() end, { desc = "Sidekick toggle" })
map({ "x", "n" }, "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, { desc = "Send this" })
map("n", "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, { desc = "Send file" })
map("x", "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, { desc = "Send selection" })
map("x", "<leader>ae", function() require("sidekick.cli").send({ prompt = "explain" }) end, { desc = "Explain" })
map("x", "<leader>ax", function() require("sidekick.cli").send({ prompt = "fix" }) end, { desc = "Fix" })
map("x", "<leader>ar", function() require("sidekick.cli").send({ prompt = "optimize" }) end, { desc = "Optimize" })
map({ "n", "x" }, "<leader>ap", function() require("sidekick.cli").prompt() end, { desc = "Select prompt" })
map("n", "<leader>as", function() require("sidekick.cli").select() end, { desc = "Select CLI" })
map("n", "<leader>ac", "<cmd>Context<cr>", { desc = "Context" })

-- Terminal
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Quickfix
map("n", "[q", "<cmd>cprev<cr>zz", { desc = "Prev quickfix" })
map("n", "]q", "<cmd>cnext<cr>zz", { desc = "Next quickfix" })
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })

-- Misc
map("n", "<leader>uu", "<cmd>Lazy update<cr>", { desc = "Update plugins" })
map("n", "<leader>um", "<cmd>Mason<cr>", { desc = "Mason" })
map("n", "<leader>ma", function() Snacks.picker.marks() end, { desc = "Marks" })
map("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer keymaps" })
map("n", "<leader>qq", "<cmd>qa!<cr>", { desc = "Quit" })
