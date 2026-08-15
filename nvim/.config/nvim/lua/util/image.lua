local M = {}

function M.switch_then_resend(cmd)
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

function M.toggle_source()
  local cur_buf = vim.api.nvim_get_current_buf()
  local path = vim.b.image_source_path or vim.api.nvim_buf_get_name(cur_buf)
  if path == "" then return end

  -- Already in a hex view (binary image) — :Hex knows how to get back.
  if vim.b.hex then return vim.cmd("Hex") end

  if vim.b.image_source_path then
    vim.cmd("edit! " .. vim.fn.fnameescape(path))
    pcall(vim.api.nvim_buf_delete, cur_buf, { force = true })
  else
    pcall(function() Snacks.image.placement.clean(cur_buf) end)
    local lines = vim.fn.readfile(path)
    -- readfile() turns NUL bytes into newlines, which nvim_buf_set_lines
    -- rejects. Only text formats (svg) round-trip; show bytes for the rest.
    for _, line in ipairs(lines) do
      if line:find("\n", 1, true) then return vim.cmd("Hex") end
    end
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
end

function M.resend_all()
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
end

-- Hide the cursor while viewing image buffers (snacks.image), restore otherwise.
function M.setup_cursor_autohide()
  local saved_guicursor = nil

  local function is_image_buf(buf)
    local name = vim.api.nvim_buf_get_name(buf)
    return name ~= ""
      and _G.Snacks
      and Snacks.image
      and Snacks.image.supports_file(name)
      and not vim.b[buf].image_source_path
      and not vim.b[buf].hex -- hex view of an image: still a .png name, but text
  end

  local function hide_cursor()
    if saved_guicursor == nil then
      saved_guicursor = vim.o.guicursor
    end
    vim.api.nvim_set_hl(0, "HiddenCursor", { blend = 100, nocombine = true })
    vim.opt.guicursor = "a:HiddenCursor/HiddenCursor"
    io.stdout:write("\27[?25l")
  end

  local function restore_cursor()
    if saved_guicursor ~= nil then
      vim.o.guicursor = saved_guicursor
      saved_guicursor = nil
    end
    io.stdout:write("\27[?25h")
  end

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    callback = function(args)
      if is_image_buf(args.buf) then
        hide_cursor()
      else
        restore_cursor()
      end
    end,
  })
end

return M
