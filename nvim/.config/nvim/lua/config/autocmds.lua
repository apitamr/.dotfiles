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

-- Set on colorscheme change
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_border_colors,
})

-- Set after UI enters (to override lazy-loaded plugins)
vim.api.nvim_create_autocmd("UIEnter", {
  callback = function()
    vim.defer_fn(set_border_colors, 100)
  end,
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
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Open Oil automatically when Neovim starts with no file arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Check if no arguments were passed (or only a directory)
    if vim.fn.argc() == 0 then
      require("oil").open()
    end
  end,
})

-- Auto-delete empty/unnamed buffers when leaving them
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(args)
    local buf = args.buf
    -- Check if buffer is unnamed and empty
    if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == "" then
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      if #lines == 1 and lines[1] == "" then
        -- Schedule deletion to avoid issues during buffer switch
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(buf) then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end)
      end
    end
  end,
})
