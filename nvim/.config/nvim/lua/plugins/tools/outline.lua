return {
  {
    "hedyhli/outline.nvim",
    cmd = "Outline",
    opts = {
      outline_window = {
        position = "left",
        width = 35,
        auto_close = false,
        focus_on_open = false,
        relative_width = false,
        no_provider_message = "",
      },
      symbol_folding = {
        autofold_depth = false,
      },
    },
    config = function(_, opts)
      -- VS Code codicon-style icons via Nerd Font codepoints
      local i = vim.fn.nr2char
      opts.symbols = {
        icons = {
          File = { icon = i(0xEB60), hl = "Identifier" },
          Module = { icon = i(0xEB5D), hl = "Include" },
          Namespace = { icon = i(0xEB5D), hl = "Include" },
          Package = { icon = i(0xEB29), hl = "Include" },
          Class = { icon = i(0xEB5B), hl = "Type" },
          Method = { icon = i(0xEA8C), hl = "Function" },
          Property = { icon = i(0xEB65), hl = "Identifier" },
          Field = { icon = i(0xEB5F), hl = "Identifier" },
          Constructor = { icon = i(0xEA8C), hl = "Special" },
          Enum = { icon = i(0xEA95), hl = "Type" },
          Interface = { icon = i(0xEB61), hl = "Type" },
          Function = { icon = i(0xEA8C), hl = "Function" },
          Variable = { icon = i(0xEA88), hl = "Constant" },
          Constant = { icon = i(0xEB5D), hl = "Constant" },
          String = { icon = i(0xEB8D), hl = "String" },
          Number = { icon = i(0xEA95), hl = "Number" },
          Boolean = { icon = i(0xEA8F), hl = "Boolean" },
          Array = { icon = i(0xEA8A), hl = "Constant" },
          Object = { icon = i(0xEA8B), hl = "Type" },
          Key = { icon = i(0xEB62), hl = "Type" },
          Null = { icon = i(0xEA8E), hl = "Type" },
          EnumMember = { icon = i(0xEB5E), hl = "Identifier" },
          Struct = { icon = i(0xEA91), hl = "Structure" },
          Event = { icon = i(0xEA86), hl = "Type" },
          Operator = { icon = i(0xEB64), hl = "Identifier" },
          TypeParameter = { icon = i(0xEA92), hl = "Identifier" },
          Component = { icon = i(0xEA8C), hl = "Function" },
          Fragment = { icon = i(0xEB5D), hl = "Constant" },
        },
      }

      require("outline").setup(opts)

      -- Auto-close outline when it's the last window
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          local function count_normal_windows()
            local count = 0
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              local config = vim.api.nvim_win_get_config(win)
              if config.relative == "" then
                count = count + 1
              end
            end
            return count
          end
          if vim.bo.filetype == "Outline" and count_normal_windows() == 1 then
            vim.cmd("q")
          end
        end,
      })
    end,
  },
}
