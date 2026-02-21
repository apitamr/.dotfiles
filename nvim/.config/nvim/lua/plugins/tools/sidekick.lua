return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
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
