return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "mocha",
    custom_highlights = function(colors)
      return {
        -- Mini.icons highlight groups
        MiniIconsAzure = { fg = colors.sapphire },
        MiniIconsBlue = { fg = colors.blue },
        MiniIconsCyan = { fg = colors.teal },
        MiniIconsGreen = { fg = colors.green },
        MiniIconsGrey = { fg = colors.overlay0 },
        MiniIconsOrange = { fg = colors.peach },
        MiniIconsPurple = { fg = colors.mauve },
        MiniIconsRed = { fg = colors.red },
        MiniIconsYellow = { fg = colors.yellow },
      }
    end,
    integrations = {
      alpha = true,
      cmp = true,
      flash = true,
      gitsigns = true,
      indent_blankline = { enabled = true },
      lsp_trouble = true,
      mason = true,
      mini = {
        enabled = true,
        indentscope_color = "lavender",
      },
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      noice = true,
      notify = true,
      nvim_web_devicons = true,
      treesitter = true,
      which_key = true,
    },
  },
}
