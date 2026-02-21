return {
  "ahkohd/context.nvim",
  cmd = { "Context" }, -- Load only when command is used
  keys = {
    { "<leader>ac", "<cmd>Context<cr>", desc = "Context" },
  },
  config = function()
    local context = require("context")

    context.setup({
      picker = context.pickers.vim_ui,
      prompts = {
        explain = "Explain {this}",
        fix = "Fix the issue at {position}",
        review = "Review {file} for issues",
        diagnose = "Help fix these diagnostics:\n{diagnostics}",
      },
    })
  end,
}
