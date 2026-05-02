-- Autocmds are automatically loaded on the VeryLazy event

-- Set border highlights for kanso theme
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#23262c", bg = "NONE" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#23262c", bg = "NONE" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#23262c", bg = "NONE" })
    vim.api.nvim_set_hl(0, "LspFloat", { bg = "#1a1a1a" })
    vim.api.nvim_set_hl(0, "LspFloatBorder", { bg = "#1a1a1a", fg = "#5c5c5c" })
  end,
})

-- LSP float window styling (solid background, border)
do
  local orig = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "rounded"
    opts.focus_id = "lsp_float"
    opts.max_width = math.min(opts.max_width or 120, 120)
    opts.max_height = math.min(opts.max_height or 20, 20)
    opts.wrap = true
    local bufnr, winnr = orig(contents, syntax, opts, ...)
    if winnr and vim.api.nvim_win_is_valid(winnr) then
      vim.wo[winnr].winblend = 0
      vim.wo[winnr].winhighlight = "Normal:LspFloat,FloatBorder:LspFloatBorder"
      vim.wo[winnr].conceallevel = 2
      vim.wo[winnr].concealcursor = "n"
      vim.api.nvim_set_current_win(winnr)
    end
    return bufnr, winnr
  end
end

-- Disable auto comment continuation on new line
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Open Oil when Neovim starts with no file arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.schedule(function() require("oil").open(vim.fn.getcwd()) end)
    end
  end,
})

-- Open file from lazygit without splits
function _G.LazygitEdit(filename, line)
  vim.schedule(function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(win).relative ~= "" then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
    vim.cmd("edit " .. vim.fn.fnameescape(filename))
    if line and line > 0 then
      pcall(vim.api.nvim_win_set_cursor, 0, { line, 0 })
    end
  end)
  return ""
end

-- Auto-delete empty unnamed buffers when leaving them
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(args)
    local buf = args.buf
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(buf) then return end
      if vim.api.nvim_buf_get_name(buf) ~= "" then return end
      if vim.bo[buf].buftype ~= "" then return end
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      if #lines == 1 and lines[1] == "" then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end, 100)
  end,
})
