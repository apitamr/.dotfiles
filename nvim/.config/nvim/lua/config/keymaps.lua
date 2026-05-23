-- Keymaps are automatically loaded on the VeryLazy event
-- Only customizations here; LazyVim defaults are left intact.

local map = vim.keymap.set

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

local function open_tree_current()
  -- Close any existing neo-tree windows so we never end up with a duplicate tree
  pcall(vim.cmd, "Neotree close")
  vim.cmd("Neotree position=current dir=" .. vim.fn.fnameescape(vim.fn.getcwd()))
end

-- Buffers
map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New buffer" })

-- Switch buffer + resend image if landing on an image buffer
local function switch_then_resend(cmd)
  return function()
    vim.cmd(cmd)
    local b = vim.api.nvim_get_current_buf()
    local name = vim.api.nvim_buf_get_name(b)
    if name == "" or not (Snacks and Snacks.image and Snacks.image.supports_file(name)) then return end
    Snacks.image.placement.clean(b)
    Snacks.image.image.clear()
    Snacks.image.buf.attach(b)
  end
end
map("n", "<S-h>", switch_then_resend("bprevious"), { desc = "Prev buffer (resend image)" })
map("n", "<S-l>", switch_then_resend("bnext"), { desc = "Next buffer (resend image)" })

local function close_current_buffer()
  local non_tree = vim.tbl_filter(function(b)
    return vim.bo[b.bufnr].filetype ~= "neo-tree"
  end, vim.fn.getbufinfo({ buflisted = 1 }))
  Snacks.bufdelete()
  if #non_tree <= 1 then
    vim.schedule(open_tree_current)
  end
end

map("n", "<leader>x", close_current_buffer, { desc = "Close buffer", nowait = true })

map("n", "<leader>bd", function()
  -- Close any floating neo-tree first
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_win_get_config(win).relative ~= "" and vim.bo[b].filetype == "neo-tree" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
  -- Open full-window tree before nuking buffers so nvim never goes empty
  open_tree_current()
  vim.schedule(function()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].filetype ~= "neo-tree" then
        pcall(vim.api.nvim_buf_delete, b, { force = true })
      end
    end
  end)
end, { desc = "Close all buffers", nowait = true })

-- Neo-tree
local function has_real_buffer()
  for _, b in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    if vim.bo[b.bufnr].filetype ~= "neo-tree" and vim.api.nvim_buf_get_name(b.bufnr) ~= "" then
      return true
    end
  end
  return false
end

local function in_fullwindow_tree()
  local wins = vim.tbl_filter(function(w)
    return vim.api.nvim_win_get_config(w).relative == ""
  end, vim.api.nvim_list_wins())
  if #wins ~= 1 then return false end
  return vim.bo[vim.api.nvim_win_get_buf(wins[1])].filetype == "neo-tree"
end

local function tree_toggle(position)
  if vim.bo.filetype == "neo-tree" or in_fullwindow_tree() then
    vim.cmd("Neotree close")
    return
  end
  if position == "current" or not has_real_buffer() then
    open_tree_current()
  else
    vim.cmd("Neotree toggle reveal position=" .. position)
  end
end

map("n", "-",         function() tree_toggle("left") end,  { desc = "Toggle file tree" })
map("n", "<leader>e", function() tree_toggle("left") end,  { desc = "Toggle sidebar tree" })
map("n", "<leader>o", function() tree_toggle("float") end, { desc = "File tree (float)" })

-- Picker (Snacks) — only non-default variants
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
map("n", "<leader>fo", function() Snacks.picker.recent() end, { desc = "Recent files" })
map("n", "<leader>fO", function() vim.v.oldfiles = {}; vim.notify("Oldfiles cleared") end, { desc = "Clear recent" })
map("n", "<leader>fz", function() Snacks.picker.grep_buffers() end, { desc = "Grep buffer" })
map("n", "gss", function() Snacks.picker.lsp_symbols() end, { desc = "Document symbols" })
map("n", "gsS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Workspace symbols" })

-- Tools (Snacks)
map("n", "<leader>h", function() Snacks.terminal() end, { desc = "Terminal" })
map("n", "<leader>th", function() Snacks.terminal.open(nil, { win = { position = "bottom" } }) end, { desc = "New terminal (horizontal)" })
map("n", "<leader>tv", function() Snacks.terminal.open(nil, { win = { position = "right" } }) end, { desc = "New terminal (vertical)" })

-- LSP (custom: Snacks pickers + custom borders)
map("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "References" })
map("n", "gi", function() Snacks.picker.lsp_implementations() end, { desc = "Implementation" })
map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Type definition" })
map("n", "K", function()
  vim.lsp.buf.hover({ border = "rounded", max_width = 80, max_height = 20 })
end, { desc = "Hover" })
map("n", "gK", function()
  vim.lsp.buf.signature_help({ border = "rounded", max_width = 80 })
end, { desc = "Signature help" })
map("i", "<C-k>", function()
  vim.lsp.buf.signature_help({ border = "rounded", max_width = 80 })
end, { desc = "Signature help" })

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
map("n", "<leader>gf", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" then Snacks.picker.git_log_file({ file = file })
  else vim.notify("No file in current buffer", vim.log.levels.WARN) end
end, { desc = "File history" })

-- Window resize
map("n", "<A-k>", "<cmd>resize +2<cr>", { desc = "Increase height" })
map("n", "<A-j>", "<cmd>resize -2<cr>", { desc = "Decrease height" })
map("n", "<A-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "<A-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })

-- Quickfix (extras over LazyVim defaults)
map("n", "<leader>qo", "<cmd>copen<cr>", { desc = "Open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<cr>", { desc = "Close quickfix" })

-- Misc
map("n", "<leader>ue", function()
  local cur_buf = vim.api.nvim_get_current_buf()
  local path = vim.b.image_source_path or vim.api.nvim_buf_get_name(cur_buf)
  if path == "" then return end

  if vim.b.image_source_path then
    -- We're in source mode → reopen the file (snacks will render the image)
    vim.cmd("edit! " .. vim.fn.fnameescape(path))
    pcall(vim.api.nvim_buf_delete, cur_buf, { force = true })
  else
    -- Switch to source mode in a fresh scratch buffer
    pcall(function() Snacks.image.placement.clean(cur_buf) end)
    local lines = vim.fn.readfile(path)
    local new_buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_buf_set_lines(new_buf, 0, -1, false, lines)
    vim.b[new_buf].image_source_path = path
    vim.b[new_buf].snacks_image_attached = true
    vim.api.nvim_buf_set_name(new_buf, path .. " [source]")
    vim.bo[new_buf].filetype = vim.filetype.match({ filename = path }) or "xml"
    vim.bo[new_buf].buftype = "acwrite"
    vim.api.nvim_create_autocmd("BufWriteCmd", {
      buffer = new_buf,
      callback = function()
        vim.fn.writefile(vim.api.nvim_buf_get_lines(new_buf, 0, -1, false), path)
        vim.bo[new_buf].modified = false
      end,
    })
    vim.api.nvim_set_current_buf(new_buf)
    pcall(vim.api.nvim_buf_delete, cur_buf, { force = true })
    vim.cmd("redraw!")
  end
end, { desc = "Toggle image/source" })
map("n", "<leader>ir", function()
  local targets = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(b) then
      local name = vim.api.nvim_buf_get_name(b)
      if name ~= "" and Snacks.image.supports_file(name) then
        targets[#targets + 1] = b
      end
    end
  end
  Snacks.image.placement.clean()
  Snacks.image.image.clear()
  for _, b in ipairs(targets) do
    Snacks.image.buf.attach(b)
  end
end, { desc = "Re-send images to terminal" })
map("n", "<leader>fm", function() Snacks.picker.marks() end, { desc = "Marks" })
map("n", "<leader>fM", function()
  vim.cmd("delmarks! | delmarks A-Z0-9")
  vim.notify("All marks cleared")
end, { desc = "Clear all marks" })
map("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Buffer keymaps" })
