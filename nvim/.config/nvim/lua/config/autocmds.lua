-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Disable LazyVim's root detection autocmd
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_root")
  end,
})

-- Set border highlights for kanso theme
local function set_border_colors()
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#23262c", bg = "NONE" })
  vim.api.nvim_set_hl(0, "VertSplit", { fg = "#23262c", bg = "NONE" })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#23262c", bg = "NONE" })
  -- LSP float with solid background
  vim.api.nvim_set_hl(0, "LspFloat", { bg = "#1a1a1a" })
  vim.api.nvim_set_hl(0, "LspFloatBorder", { bg = "#1a1a1a", fg = "#5c5c5c" })
end

-- Set on colorscheme change (run once)
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_border_colors,
  once = true, -- Only run once to reduce overhead
})

-- LSP float window styling (solid background, border)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    -- Only override once
    if vim.g.lsp_float_override then
      return
    end
    vim.g.lsp_float_override = true

    vim.diagnostic.config({
      float = { border = "rounded" },
    })

    local orig = vim.lsp.util.open_floating_preview
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
      opts = opts or {}
      opts.border = opts.border or "rounded"
      opts.focus_id = "lsp_float"
      local bufnr, winnr = orig(contents, syntax, opts, ...)
      if winnr and vim.api.nvim_win_is_valid(winnr) then
        vim.wo[winnr].winblend = 0
        vim.wo[winnr].winhighlight = "Normal:LspFloat,FloatBorder:LspFloatBorder"
        -- Auto focus the float window
        vim.api.nvim_set_current_win(winnr)
      end
      return bufnr, winnr
    end
  end,
})

-- Disable auto comment continuation on new line (enforce for all filetypes)
-- Using BufEnter with debounce instead of FileType for better performance
local format_opts_timer = nil
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if format_opts_timer then
      vim.fn.timer_stop(format_opts_timer)
    end
    format_opts_timer = vim.fn.timer_start(50, function()
      vim.opt_local.formatoptions:remove({ "c", "r", "o" })
    end)
  end,
})

-- Oil minimal style (no extra padding)
vim.api.nvim_create_autocmd({ "FileType", "BufEnter", "BufWinEnter" }, {
  pattern = { "oil", "oil://*" },
  callback = function()
    vim.schedule(function()
      vim.opt_local.signcolumn = "no"
      vim.opt_local.foldcolumn = "0"
      vim.opt_local.statuscolumn = ""
      vim.opt_local.numberwidth = 1
    end)
  end,
})

-- Open Oil automatically when Neovim starts with no file arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Check if no arguments were passed (or only a directory)
    if vim.fn.argc() == 0 then
      vim.schedule(function()
        require("oil").open(vim.fn.getcwd())
      end)
    end
  end,
})

-- Open file from lazygit without splits
function _G.LazygitEdit(filename, line)
  vim.schedule(function()
    -- Close all floating windows (lazygit)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.relative ~= "" then
        pcall(vim.api.nvim_win_close, win, true)
      end
    end
    -- Open the file in the current window
    vim.cmd("edit " .. vim.fn.fnameescape(filename))
    if line and line > 0 then
      pcall(vim.api.nvim_win_set_cursor, 0, { line, 0 })
    end
  end)
  return ""
end

-- Auto-delete empty/unnamed buffers when leaving them (debounced)
local buf_cleanup_timer = nil
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(args)
    local buf = args.buf
    -- Debounce to avoid running on rapid buffer switches
    if buf_cleanup_timer then
      vim.fn.timer_stop(buf_cleanup_timer)
    end
    buf_cleanup_timer = vim.fn.timer_start(100, function()
      -- Check if buffer is unnamed and empty
      if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_name(buf) == "" then
        local ok, buftype = pcall(function() return vim.bo[buf].buftype end)
        if ok and buftype == "" then
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          if #lines == 1 and lines[1] == "" then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
      end
    end)
  end,
})
