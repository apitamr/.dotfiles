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
      default = "claude",
    },
  },
  keys = {
    {
      "<c-.>",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Sidekick Toggle",
    },
    {
      "<leader>at",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    {
      "<leader>af",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send File",
    },
    {
      "<leader>av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Selection",
    },
    {
      "<leader>ae",
      function()
        require("sidekick.cli").send({ msg = "Explain {selection}" })
      end,
      mode = { "x" },
      desc = "Explain Selection",
    },
    {
      "<leader>ax",
      function()
        require("sidekick.cli").send({ msg = "Fix {selection}" })
      end,
      mode = { "x" },
      desc = "Fix Selection",
    },
    {
      "<leader>ar",
      function()
        require("sidekick.cli").send({ msg = "Refactor {selection}" })
      end,
      mode = { "x" },
      desc = "Refactor Selection",
    },
  },
}
