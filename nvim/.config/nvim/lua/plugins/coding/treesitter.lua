return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- Big-file handling (disabling treesitter/LSP/folds) lives in snacks
    -- `bigfile`. The old `highlight`/`indent` disable options don't exist on
    -- the `main` branch, so a guard here would be dead code.
    opts = {
      auto_install = false,
    },
  },
}
