-- Autocmds are automatically loaded on the VeryLazy event

local image = require("util.image")
local buffer = require("util.buffer")

-- Big-file handling. LazyVim's treesitter/LSP/fold guards only fire when the
-- filetype is `bigfile`, and snacks' detector (which sets that filetype) loses
-- to Neovim's extension matching for files like .lua/.js — so large code files
-- keep everything running and crawl. Instead of fighting filetype priority,
-- disable the expensive features directly, keyed on file size.
local BIGFILE_SIZE = 1 * 1024 * 1024 -- 1 MB

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    local buf = args.buf
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
    if not (ok and stats and stats.size > BIGFILE_SIZE) then return end
    vim.b[buf].bigfile = true
    vim.api.nvim_buf_call(buf, function()
      vim.wo.foldmethod = "manual" -- expr folds are O(file)
      vim.wo.foldexpr = "0"
    end)
    -- Defer past the FileType event that starts treesitter / attaches LSP.
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(buf) then return end
      pcall(vim.treesitter.stop, buf)
      vim.bo[buf].syntax = ""
      for _, c in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
        vim.lsp.buf_detach_client(buf, c.id)
      end
    end)
  end,
})

-- Keep LSP off big files even if a server attaches after the deferred detach.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    if vim.b[args.buf].bigfile then
      vim.schedule(function()
        pcall(vim.lsp.buf_detach_client, args.buf, args.data.client_id)
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#23262c", bg = "NONE" })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = "#23262c", bg = "NONE" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#23262c", bg = "NONE" })
    vim.api.nvim_set_hl(0, "LspFloat", { bg = "#1a1a1a" })
    vim.api.nvim_set_hl(0, "LspFloatBorder", { bg = "#1a1a1a", fg = "#5c5c5c" })
  end,
})

-- LSP float window styling (solid background, sizing, focus).
require("util.lsp").setup_floating_preview()

-- Reapply the colorscheme on SIGUSR1 (sent by a tmux hook on session switch),
-- which otherwise resets the transparent background to a solid one. Signal
-- fires in a fast context where :colorscheme is blocked, and the post-switch
-- event that resets the background lands shortly after, so defer past it.
vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = function()
    vim.defer_fn(function()
      vim.cmd.colorscheme("kanso")
    end, 200)
  end,
})

-- Disable auto comment continuation on new line
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Open Neo-tree (full window) when Neovim starts with no file arguments
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.schedule(function()
        vim.cmd("Neotree position=current dir=" .. vim.fn.fnameescape(vim.fn.getcwd()))
      end)
    end
  end,
})

-- :Hex toggles an editable hex view of the current file, `:w` pipes it back
-- through `xxd -r`. Bytes come from disk rather than from a `%!xxd` filter:
-- snacks conceals image buffers (a filtered buffer just renders blank) and a
-- non-'binary' read mangles NULs. Toggling off is a plain `:edit!`, which
-- also lets snacks redraw the image.
vim.api.nvim_create_user_command("Hex", function()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" then return vim.notify("Hex: buffer has no file", vim.log.levels.WARN) end

  if vim.b.hex then
    if vim.bo.modified then return vim.notify("Hex: unsaved changes, :w first", vim.log.levels.WARN) end
    vim.b.hex, vim.b.snacks_image_attached = nil, nil
    vim.bo.buftype = ""
    vim.cmd("edit!")
    vim.cmd("doautocmd BufEnter") -- re-run the image cursor-autohide check
    return
  end

  local hex = vim.fn.systemlist({ "xxd", path })
  if vim.v.shell_error ~= 0 then return vim.notify(table.concat(hex, "\n"), vim.log.levels.ERROR) end

  vim.b.snacks_image_attached = true -- keep snacks from drawing over the hex
  pcall(function() Snacks.image.placement.clean(buf) end)
  vim.bo.modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, hex)
  vim.bo.filetype = "xxd"
  vim.bo.buftype = "acwrite" -- so BufWriteCmd handles :w
  vim.bo.modified = false
  vim.wo.conceallevel = 0
  vim.b.hex = true
  vim.cmd("doautocmd BufEnter") -- image cursor-autohide: bring the cursor back

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    buffer = buf,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      vim.fn.system(
        { "sh", "-c", "xxd -r > " .. vim.fn.shellescape(path) },
        table.concat(lines, "\n") .. "\n"
      )
      if vim.v.shell_error ~= 0 then return vim.notify("Hex: write failed", vim.log.levels.ERROR) end
      vim.bo[buf].modified = false
    end,
  })
end, { desc = "Toggle hex view (xxd)" })

-- Open file from lazygit without splits (called by the lazygit edit command)
_G.LazygitEdit = buffer.lazygit_edit

-- Hide cursor when viewing image buffers (snacks.image)
image.setup_cursor_autohide()

-- Auto-delete empty unnamed buffers when leaving them
vim.api.nvim_create_autocmd("BufLeave", {
  callback = function(args)
    local buf = args.buf
    vim.defer_fn(function() buffer.cleanup_if_empty(buf) end, 100)
  end,
})
