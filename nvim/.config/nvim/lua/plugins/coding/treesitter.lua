return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = false,
      highlight = {
        enable = true,
        disable = function(_, buf)
          local ok, stats = pcall((vim.uv or vim.loop).fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > 100 * 1024
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = function(_, buf)
          local ok, stats = pcall((vim.uv or vim.loop).fs_stat, vim.api.nvim_buf_get_name(buf))
          return ok and stats and stats.size > 100 * 1024
        end,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
  },
}
