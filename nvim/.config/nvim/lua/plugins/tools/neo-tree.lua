return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    cmd = "Neotree",
    init = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
    opts = {
      close_if_last_window = false,
      enable_git_status = true,
      enable_diagnostics = true,
      popup_border_style = "rounded",
      sources = { "filesystem", "buffers", "git_status" },
      source_selector = {
        winbar = true,
        sources = {
          { source = "filesystem", display_name = "  Files " },
          { source = "buffers",    display_name = "  Bufs " },
          { source = "git_status", display_name = "  Git " },
        },
      },
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 0,
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          highlight = "NeoTreeIndentMarker",
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          default = "",
        },
        modified = { symbol = "●" },
        git_status = {
          symbols = {
            added     = "",
            modified  = "",
            deleted   = "",
            renamed   = "󰁕",
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },
      window = {
        position = "left",
        width = 34,
        mapping_options = { noremap = true, nowait = true },
        mappings = {
          ["<space>"] = "none",
          ["<cr>"] = "open",
          ["<esc>"] = "cancel",
          ["P"] = { "toggle_preview", config = { use_float = true } },
          ["<C-v>"] = "open_vsplit",
          ["<C-s>"] = "open_split",
          ["<C-t>"] = "open_tabnew",
          ["a"] = { "add", config = { show_path = "relative" } },
          ["A"] = "add_directory",
          ["d"] = "delete",
          ["r"] = "rename",
          ["y"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["c"] = "copy",
          ["m"] = "move",
          ["q"] = "close_window",
          ["R"] = "refresh",
          ["?"] = "show_help",
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["g?"] = "show_help",
        },
      },
      filesystem = {
        bind_to_cwd = true,
        cwd_target = { sidebar = "tab", current = "window" },
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { ".git", ".DS_Store" },
        },
        follow_current_file = { enabled = true, leave_dirs_open = true },
        group_empty_dirs = false,
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_current",
      },
      buffers = {
        follow_current_file = { enabled = true },
        group_empty_dirs = false,
        show_unloaded = true,
      },
      git_status = {
        window = { position = "float" },
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.signcolumn = "no"
            vim.opt_local.cursorline = true
          end,
        },
      },
    },
  },
}
