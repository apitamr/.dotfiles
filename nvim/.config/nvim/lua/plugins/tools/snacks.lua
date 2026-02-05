return {
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        enabled = false,
      },
      explorer = {
        enabled = false,
      },
      lazygit = {
        configure = true,
        config = {
          os = {
            editPreset = "",
            edit = [[nvim --server "$NVIM" --remote-expr "v:lua.LazygitEdit('{{filename}}')"]],
            editAtLine = [[nvim --server "$NVIM" --remote-expr "v:lua.LazygitEdit('{{filename}}', {{line}})"]],
            editAtLineAndWait = [[nvim --server "$NVIM" --remote-expr "v:lua.LazygitEdit('{{filename}}', {{line}})"]],
            editInTerminal = false,
            openDirInEditor = [[nvim --server "$NVIM" --remote-expr "v:lua.LazygitEdit('{{filename}}')"]],
          },
        },
        theme = {
          [241] = { fg = "Special" },
          activeBorderColor = { fg = "MatchParen", bold = true },
          cherryPickedCommitBgColor = { fg = "Identifier" },
          cherryPickedCommitFgColor = { fg = "Function" },
          defaultFgColor = { fg = "Normal" },
          inactiveBorderColor = { fg = "Normal" },
          optionsTextColor = { fg = "Function" },
          searchingActiveBorderColor = { fg = "MatchParen", bold = true },
          selectedLineBgColor = { bg = "Visual" },
          unstagedChangesColor = { fg = "DiagnosticError" },
        },
      },
      picker = {
        layout = {
          layout = {
            box = "horizontal",
            width = 0.8,
            height = 0.8,
            {
              box = "vertical",
              { win = "list", title = "{source} {live}", border = "rounded" },
              { win = "input", height = 1, border = "rounded" },
            },
            { win = "preview", width = 0.5, border = "rounded" },
          },
        },
      },
      input = {
        enabled = false,
      },
    },
  },
}
