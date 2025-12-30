return {
  -- Disable mini.icons from LazyVim
  { "nvim-mini/mini.icons", enabled = false },

  -- Use nvim-web-devicons with catppuccin mocha colors applied to ALL icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    dependencies = { "catppuccin/nvim" },
    config = function()
      -- Setup devicons first with defaults
      require("nvim-web-devicons").setup({
        color_icons = true,
        default = true,
      })

      -- Get catppuccin latte palette
      require("catppuccin").setup({ flavour = "latte" })
      local icon_color_palette = require("catppuccin.palettes").get_palette("latte")

      -- Map common colors to palette equivalents
      local color_map = {
        -- Blues
        ["#519aba"] = icon_color_palette.blue,
        ["#51a0cf"] = icon_color_palette.blue,
        ["#42a5f5"] = icon_color_palette.blue,
        ["#6d8086"] = icon_color_palette.blue,
        ["#358a5b"] = icon_color_palette.sapphire,
        ["#007acc"] = icon_color_palette.sapphire,
        ["#0288d1"] = icon_color_palette.sapphire,
        -- Greens
        ["#8dc149"] = icon_color_palette.green,
        ["#7cb342"] = icon_color_palette.green,
        ["#89e051"] = icon_color_palette.green,
        ["#019833"] = icon_color_palette.green,
        ["#427819"] = icon_color_palette.green,
        ["#4d9375"] = icon_color_palette.teal,
        ["#1abc9c"] = icon_color_palette.teal,
        -- Yellows
        ["#cbcb41"] = icon_color_palette.yellow,
        ["#f1e05a"] = icon_color_palette.yellow,
        ["#ffca28"] = icon_color_palette.yellow,
        ["#e8d44d"] = icon_color_palette.yellow,
        ["#f0db4f"] = icon_color_palette.yellow,
        ["#ffb13b"] = icon_color_palette.yellow,
        -- Oranges/Peach
        ["#e37933"] = icon_color_palette.peach,
        ["#d4843e"] = icon_color_palette.peach,
        ["#f5871f"] = icon_color_palette.peach,
        ["#ce6620"] = icon_color_palette.peach,
        ["#ff5722"] = icon_color_palette.peach,
        ["#e44d26"] = icon_color_palette.peach,
        ["#f16529"] = icon_color_palette.peach,
        ["#ff6d00"] = icon_color_palette.peach,
        ["#cc6699"] = icon_color_palette.peach,
        -- Reds
        ["#cc3e44"] = icon_color_palette.red,
        ["#e51e1e"] = icon_color_palette.red,
        ["#e34c26"] = icon_color_palette.red,
        ["#cb171e"] = icon_color_palette.red,
        ["#b03c2d"] = icon_color_palette.red,
        ["#c62828"] = icon_color_palette.red,
        ["#e8274b"] = icon_color_palette.red,
        ["#fb503b"] = icon_color_palette.red,
        -- Purples/Mauve
        ["#a074c4"] = icon_color_palette.mauve,
        ["#834f79"] = icon_color_palette.mauve,
        ["#9c27b0"] = icon_color_palette.mauve,
        ["#6e1e8e"] = icon_color_palette.mauve,
        ["#854cc7"] = icon_color_palette.mauve,
        ["#7c4dff"] = icon_color_palette.mauve,
        ["#5849be"] = icon_color_palette.mauve,
        -- Pinks
        ["#ff69b4"] = icon_color_palette.pink,
        ["#e535ab"] = icon_color_palette.pink,
        ["#f55385"] = icon_color_palette.pink,
        -- Cyan/Sky
        ["#29b8d8"] = icon_color_palette.sky,
        ["#0095d5"] = icon_color_palette.sky,
        ["#00bcd4"] = icon_color_palette.sky,
        ["#2196f3"] = icon_color_palette.sky,
        ["#00add8"] = icon_color_palette.sky,
        -- Lavender
        ["#b4befe"] = icon_color_palette.lavender,
        -- Grays
        ["#6d6d6d"] = icon_color_palette.overlay0,
        ["#b7b8b9"] = icon_color_palette.overlay1,
        ["#7f7f7f"] = icon_color_palette.overlay0,
        ["#bbbbbb"] = icon_color_palette.subtext0,
        ["#ffffff"] = icon_color_palette.text,
      }

      -- Get all icons and remap colors
      local devicons = require("nvim-web-devicons")
      local all_icons = devicons.get_icons()
      local overrides = {}

      for name, icon in pairs(all_icons) do
        local new_color = icon.color
        -- Try exact match first
        if icon.color and color_map[icon.color:lower()] then
          new_color = color_map[icon.color:lower()]
        elseif icon.color then
          -- Fallback: map by color hue
          local hex = icon.color:lower():gsub("#", "")
          if #hex == 6 then
            local r = tonumber(hex:sub(1, 2), 16) or 0
            local g = tonumber(hex:sub(3, 4), 16) or 0
            local b = tonumber(hex:sub(5, 6), 16) or 0

            -- Determine dominant color and map to palette
            if r > g and r > b then
              if r > 200 and g < 100 then
                new_color = icon_color_palette.red
              else
                new_color = icon_color_palette.peach
              end
            elseif g > r and g > b then
              new_color = icon_color_palette.green
            elseif b > r and b > g then
              if b > 150 and r > 100 then
                new_color = icon_color_palette.mauve
              else
                new_color = icon_color_palette.blue
              end
            elseif r > 200 and g > 200 then
              new_color = icon_color_palette.yellow
            elseif r > 150 and b > 150 then
              new_color = icon_color_palette.pink
            elseif g > 150 and b > 150 then
              new_color = icon_color_palette.teal
            else
              new_color = icon_color_palette.text
            end
          end
        end

        overrides[name] = {
          icon = icon.icon,
          color = new_color,
          cterm_color = icon.cterm_color,
          name = icon.name,
        }
      end

      -- Apply all overrides
      devicons.set_icon(overrides)
    end,
  },
}
