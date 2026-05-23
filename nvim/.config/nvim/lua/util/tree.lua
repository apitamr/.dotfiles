local M = {}

function M.open_current()
  pcall(vim.cmd, "Neotree close")
  vim.cmd("Neotree position=current dir=" .. vim.fn.fnameescape(vim.fn.getcwd()))
end

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

function M.toggle(position)
  if vim.bo.filetype == "neo-tree" or in_fullwindow_tree() then
    vim.cmd("Neotree close")
    return
  end
  if position == "current" or not has_real_buffer() then
    M.open_current()
  else
    vim.cmd("Neotree toggle reveal position=" .. position)
  end
end

function M.close_current_buffer()
  local non_tree = vim.tbl_filter(function(b)
    return vim.bo[b.bufnr].filetype ~= "neo-tree"
  end, vim.fn.getbufinfo({ buflisted = 1 }))
  Snacks.bufdelete()
  if #non_tree <= 1 then
    vim.schedule(M.open_current)
  end
end

function M.close_all_buffers()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_win_get_config(win).relative ~= "" and vim.bo[b].filetype == "neo-tree" then
      pcall(vim.api.nvim_win_close, win, true)
    end
  end
  M.open_current()
  vim.schedule(function()
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].filetype ~= "neo-tree" then
        pcall(vim.api.nvim_buf_delete, b, { force = true })
      end
    end
  end)
end

return M
