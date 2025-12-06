return {
  'gisketch/triforce.nvim',
  dependencies = { 'nvzone/volt' },
  config = function()
    require('triforce').setup({
      -- Optional: Add your configuration here
      -- Keymaps are now defined in lua/config/keymaps.lua
      keymap = false, -- Disable default keymaps
    })
  end,
}
