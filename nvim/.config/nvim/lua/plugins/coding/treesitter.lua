local function big_file(_, buf)
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
  return ok and stats and stats.size > 100 * 1024
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = false,
      highlight = {
        enable = true,
        disable = big_file,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = big_file,
      },
    },
  },
}
