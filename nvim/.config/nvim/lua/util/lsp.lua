local M = {}

-- Override LSP float windows: solid background, sizing, focus.
-- Border comes from the global `winborder` option.
function M.setup_floating_preview()
  local orig = vim.lsp.util.open_floating_preview
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    opts = opts or {}
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

return M
