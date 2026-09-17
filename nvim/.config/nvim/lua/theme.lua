-- Follows Ghostty's `theme = Kanso <Variant>` and `background-opacity`; reload with `pkill -USR1 nvim`
local M = {}

local fallback = "kanso-zen"

local function ghostty()
    local path = vim.fn.expand("~/.config/ghostty/config")
    local settings = { transparent = false }
    if vim.fn.filereadable(path) == 0 then
        return settings
    end

    for _, line in ipairs(vim.fn.readfile(path)) do
        local variant = line:match("^%s*theme%s*=%s*[Kk]anso[%s%-]+(%a+)")
        if variant then
            settings.scheme = "kanso-" .. variant:lower()
        end

        local opacity = tonumber(line:match("^%s*background%-opacity%s*=%s*([%d%.]+)"))
        if opacity then
            settings.transparent = settings.transparent or opacity < 1
        end

        -- An image only shows through default-background cells too
        if line:match("^%s*background%-image%s*=%s*%S") then
            settings.transparent = true
        end
    end

    return settings
end

-- Popups keep the theme's solid colors; only the editor itself lets the image through
local popup_groups = { "^NormalFloat$", "^Float", "^Pmenu", "^Blink", "^Snacks", "^Notify", "^MiniPick", "^Telescope", "^Floaterm" }

local function solid_popups()
    local config = vim.tbl_extend("force", require("kanso").config, { transparent = false })
    local colors = require("kanso.colors").setup()
    for name, spec in pairs(require("kanso.highlights").setup(colors, config)) do
        for _, pattern in ipairs(popup_groups) do
            if name:match(pattern) then
                vim.api.nvim_set_hl(0, name, spec)
                break
            end
        end
    end
end

function M.apply()
    local settings = ghostty()
    -- Ghostty only makes default-background cells transparent
    require("kanso").config.transparent = settings.transparent

    if not pcall(vim.cmd.colorscheme, settings.scheme or fallback) then
        vim.cmd.colorscheme(fallback)
    end

    if settings.transparent then
        solid_popups()
    end
end

function M.reload()
    M.apply()
    vim.notify("Theme reloaded: " .. vim.g.colors_name)
end

return M
