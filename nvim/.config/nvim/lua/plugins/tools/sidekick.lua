return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>aa", function() require("sidekick.cli").toggle() end, desc = "Sidekick toggle" },
    { "<leader>at", function() require("sidekick.cli").send({ msg = "{this}" }) end, mode = { "n", "x" }, desc = "Send this" },
    { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Send file" },
    { "<leader>av", function() require("sidekick.cli").send({ msg = "{selection}" }) end, mode = "x", desc = "Send selection" },
    { "<leader>ae", function() require("sidekick.cli").send({ prompt = "explain" }) end, mode = "x", desc = "Explain" },
    { "<leader>ax", function() require("sidekick.cli").send({ prompt = "fix" }) end, mode = "x", desc = "Fix" },
    { "<leader>ar", function() require("sidekick.cli").send({ prompt = "optimize" }) end, mode = "x", desc = "Optimize" },
    { "<leader>ap", function() require("sidekick.cli").prompt() end, mode = { "n", "x" }, desc = "Select prompt" },
    { "<leader>as", function() require("sidekick.cli").select() end, desc = "Select CLI" },
  },
  opts = {
    nes = {
      enabled = false,
    },
    cli = {
      mux = {
        enabled = false,
      },
    },
  },
  config = function(_, opts)
    require("sidekick").setup(opts)
    -- remove tmux/zellij backends so they don't show duplicate external sessions
    local Session = require("sidekick.cli.session")
    Session.setup()
    Session.backends["tmux"] = nil
    Session.backends["zellij"] = nil
  end,
}
