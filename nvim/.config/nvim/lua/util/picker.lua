-- Snacks picker helpers that need more than a one-line wrapper.
local M = {}

-- Grep the current visual selection.
function M.grep_selection()
  local _, sr, sc = unpack(vim.fn.getpos("v"))
  local _, er, ec = unpack(vim.fn.getpos("."))
  if sr > er or (sr == er and sc > ec) then sr, er, sc, ec = er, sr, ec, sc end
  local lines = vim.fn.getline(sr, er)
  if #lines == 0 then return end
  if #lines == 1 then
    lines[1] = lines[1]:sub(sc, ec)
  else
    lines[1] = lines[1]:sub(sc)
    lines[#lines] = lines[#lines]:sub(1, ec)
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  vim.schedule(function() Snacks.picker.grep({ search = table.concat(lines, "\n") }) end)
end

-- Git history for the file in the current buffer.
function M.git_file_history()
  local file = vim.api.nvim_buf_get_name(0)
  if file ~= "" then
    Snacks.picker.git_log_file({ file = file })
  else
    vim.notify("No file in current buffer", vim.log.levels.WARN)
  end
end

-- Clear the recent-files (oldfiles) list.
function M.clear_recent()
  vim.v.oldfiles = {}
  vim.notify("Oldfiles cleared")
end

-- Clear all marks (lowercase, uppercase, and numbered).
function M.clear_marks()
  vim.cmd("delmarks! | delmarks A-Z0-9")
  vim.notify("All marks cleared")
end

return M
