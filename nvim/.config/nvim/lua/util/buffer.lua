local M = {}

-- Open a file from lazygit without splits; closes any floating windows first.
-- Exposed globally as `_G.LazygitEdit` (called by the lazygit edit command).
function M.lazygit_edit(filename, line)
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

-- Delete the buffer if it is an unnamed, empty, normal buffer.
function M.cleanup_if_empty(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if vim.api.nvim_buf_get_name(buf) ~= "" then return end
  if vim.bo[buf].buftype ~= "" then return end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  if #lines == 1 and lines[1] == "" then
    pcall(vim.api.nvim_buf_delete, buf, { force = true })
  end
end

return M
