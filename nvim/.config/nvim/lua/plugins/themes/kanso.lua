return {
  "webhooked/kanso.nvim",
  lazy = false,
  opts = {
    background = "zen",
    dimInactive = false,
    foreground = {
      light = "saturated",
      dark = "saturated",
    },
    bold = false,
    italics = false,
    transparent = true,
  },
  config = function(_, opts)
    require("kanso").setup(opts)
    vim.cmd.colorscheme("kanso")
  end,
}
