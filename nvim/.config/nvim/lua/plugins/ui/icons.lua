return {
  { "nvim-mini/mini.icons", enabled = false },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    opts = { color_icons = true, default = true },
    config = function(_, opts)
      local devicons = require("nvim-web-devicons")
      devicons.setup(opts)
      local function reapply() devicons.set_up_highlights(true) end
      reapply()
      vim.api.nvim_create_autocmd({ "ColorScheme", "BufEnter" }, {
        group = vim.api.nvim_create_augroup("DevIconsForceColors", { clear = true }),
        callback = function() vim.defer_fn(reapply, 0) end,
      })
    end,
  },
}
