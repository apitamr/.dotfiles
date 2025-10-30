-- CodeCompanion - AI Coding Assistant
-- All configuration, keymaps, and spinner functionality in one place

return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "j-hui/fidget.nvim", -- For progress notifications
    },

    -- Initialize Fidget.nvim progress integration
    init = function()
      local progress = require("fidget.progress")

      local handles = {}

      local function store_progress_handle(id, handle)
        handles[id] = handle
      end

      local function pop_progress_handle(id)
        local handle = handles[id]
        handles[id] = nil
        return handle
      end

      local function llm_role_title(adapter)
        local parts = {}
        table.insert(parts, adapter.formatted_name)
        if adapter.model and adapter.model ~= "" then
          table.insert(parts, "(" .. adapter.model .. ")")
        end
        return table.concat(parts, " ")
      end

      local function create_progress_handle(request)
        local title = string.format("CodeCompanion [%s]", request.data.strategy)
        return progress.handle.create({
          title = title,
          message = llm_role_title(request.data.adapter),
          lsp_client = {
            name = "CodeCompanion",
          },
        })
      end

      local function report_exit_status(handle, request)
        if request.data.status == "success" then
          handle.message = "Completed"
        elseif request.data.status == "error" then
          handle.message = " Error"
        else
          handle.message = "󰜺 Cancelled"
        end
      end

      -- Setup autocommands
      local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequestStarted",
        group = group,
        callback = function(request)
          local handle = create_progress_handle(request)
          store_progress_handle(request.data.id, handle)
        end,
      })

      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequestFinished",
        group = group,
        callback = function(request)
          local handle = pop_progress_handle(request.data.id)
          if handle then
            report_exit_status(handle, request)
            handle:finish()
          end
        end,
      })
    end,

    -- Plugin options
    opts = {
      -- Adapter configuration
      adapters = {
        acp = {
          claude_code = function()
            -- Load token from secrets.lua (not in version control)
            local ok, secrets = pcall(require, "secrets")
            local token = ok and secrets.claude_token or nil

            if not token then
              vim.notify("Claude token not found. Please configure lua/secrets.lua", vim.log.levels.ERROR)
              return nil
            end

            return require("codecompanion.adapters").extend("claude_code", {
              env = {
                CLAUDE_CODE_OAUTH_TOKEN = token,
              },
            })
          end,
        },
      },

      -- Default adapter strategies
      strategies = {
        chat = {
          adapter = "claude_code", -- Use Claude Code for chat
        },
        inline = {
          adapter = "copilot", -- Use Copilot for inline suggestions
        },
        cmd = {
          adapter = "copilot", -- Use Copilot for commands (claude_code ACP adapter not supported for cmd strategy)
        },
      },

      -- Display configuration
      display = {
        action_palette = {
          provider = "default", -- Use default provider (snacks has compatibility issues)
          width = 95,
          height = 10,
        },
        chat = {
          window = {
            layout = "vertical", -- float|vertical|horizontal|buffer
            width = 0.45,
            height = 0.8,
            relative = "editor",
            border = "single",
            sticky = false,
          },
          auto_scroll = true,
          intro_message = "Welcome to CodeCompanion ✨! Press ? for options",
          separator = "─",
          show_settings = true,
          show_token_count = true,
          token_count = function(tokens, adapter)
            return " (" .. tokens .. " tokens)"
          end,
        },
      },

      -- Logging
      log_level = "INFO", -- TRACE|DEBUG|INFO|WARN|ERROR
    },

    -- Commands (lazy-loaded)
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },

    -- Setup function
    config = function(_, opts)
      require("codecompanion").setup(opts)

      -- Suppress invalid buffer errors
      local original_notify = vim.notify
      vim.notify = function(msg, level, notify_opts)
        if msg and msg:match("Invalid buffer id") then
          return -- Suppress this specific error
        end
        original_notify(msg, level, notify_opts)
      end
    end,
  },
}
