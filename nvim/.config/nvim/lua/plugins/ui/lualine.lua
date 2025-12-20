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
      },
      sections = {
        lualine_c = {
          {
            "filename",
            path = 3,
            cond = function()
              return vim.bo.buftype == ""
            end,
          },
        },
      },
    })
  end,
 }
