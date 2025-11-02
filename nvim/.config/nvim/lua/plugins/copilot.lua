return {
  "github/copilot.vim",
  event = "InsertEnter",
  config = function()
    -- Copilot settings (keybindings are in lua/config/keymaps.lua)
    vim.g.copilot_enabled = 0
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
  end,
}
