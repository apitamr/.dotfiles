-- Change to the directory when Neovim is opened with a path argument
local function change_to_arg_dir()
  if vim.fn.argc() > 0 then
    local arg = vim.fn.argv(0)
    local fullpath = vim.fn.fnamemodify(arg, ":p")

    local target_dir
    if vim.fn.isdirectory(fullpath) == 1 then
      target_dir = fullpath
    elseif vim.fn.filereadable(fullpath) == 1 then
      target_dir = vim.fn.fnamemodify(fullpath, ":p:h")
    end

    if target_dir and vim.fn.isdirectory(target_dir) == 1 then
      vim.cmd("cd " .. vim.fn.fnameescape(target_dir))
    end
  end
end

change_to_arg_dir()

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
