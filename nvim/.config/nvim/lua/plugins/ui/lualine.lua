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
        globalstatus = true, -- Single statusline (less rendering)
        refresh = {
          statusline = 500, -- Refresh every 500ms instead of 100ms
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            path = 1, -- Relative path (shorter)
            cond = function()
              return vim.bo.buftype == ""
            end,
          },
        },
        lualine_x = {}, -- Remove encoding/fileformat
        lualine_y = { "progress" }, -- Keep progress
        lualine_z = {}, -- Remove location (visible in ruler)
      },
      inactive_sections = {
        lualine_c = { "filename" },
        lualine_x = {},
      },
    })
  end,
}
