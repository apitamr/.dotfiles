return {
  "nvim-lualine/lualine.nvim",
  optional = true,
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        theme = "kanso",
        component_separators = "",
        section_separators = "",
        globalstatus = true,
        refresh = {
          statusline = 500,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          { "branch", icon = "" },
        },
        lualine_c = {
          {
            "filename",
            path = 1,
            symbols = { modified = " ●", readonly = " ", unnamed = "[No Name]" },
            cond = function()
              return vim.bo.buftype == ""
            end,
          },
        },
        lualine_x = {
          {
            "diagnostics",
            symbols = { error = " ", warn = " ", info = " ", hint = " " },
          },
        },
        lualine_y = { "filetype" },
        lualine_z = { "progress" },
      },
      inactive_sections = {
        lualine_c = {
          { "filename", path = 1 },
        },
        lualine_x = {},
      },
    })
  end,
}
