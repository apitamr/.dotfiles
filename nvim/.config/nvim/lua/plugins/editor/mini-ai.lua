return {
  {
    "nvim-mini/mini.ai",
    event = "VeryLazy",
    opts = function(_, opts)
      local function safe(fn)
        return function(...)
          local ok, result = pcall(fn, ...)
          if ok then
            return result
          end
        end
      end

      opts.custom_textobjects = opts.custom_textobjects or {}
      for k, v in pairs(opts.custom_textobjects) do
        if type(v) == "function" then
          opts.custom_textobjects[k] = safe(v)
        end
      end
      return opts
    end,
  },
}
