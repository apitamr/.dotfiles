return {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  opts = {
    nes = {
      enabled = false,
    },
    cli = {
      mux = {
        backend = "tmux", -- or "zellij" if you use that
        enabled = false, -- disable session persistence (closes CLI when vim exits)
      },
      default = "opencode", -- use opencode as default CLI tool
      win = {
        keys = {
          -- Add Esc Esc to leave terminal mode
          stopinsert_esc = { "<Esc><Esc>", "stopinsert", mode = "t", desc = "exit terminal mode" },
        },
      },
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
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
      desc = "Sidekick Toggle CLI",
    },
    {
      "<leader>as",
      function()
        require("sidekick.cli").select()
      end,
      desc = "Select CLI",
    },
    {
      "<leader>ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Detach a CLI Session",
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
      desc = "Send Visual Selection",
    },
    -- Selection with prompts
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
    {
      "<leader>ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
    -- Toggle specific CLI tools
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Sidekick Toggle Claude",
    },
    {
      "<leader>ao",
      function()
        require("sidekick.cli").toggle({ name = "opencode", focus = true })
      end,
      desc = "Sidekick Toggle OpenCode",
    },
  },
}
