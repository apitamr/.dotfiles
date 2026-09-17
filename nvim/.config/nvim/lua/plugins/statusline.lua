return {

    plugin = {
        src = "https://github.com/echasnovski/mini.statusline",
    },

    config = function()
        -- Not 3: is_truncated() measures the whole screen instead of the window
        vim.o.laststatus = 2

        local statusline = require("mini.statusline")

        local diagnostic = require("icons").diagnostic

        local icon = {
            branch = "\u{E0A0}",
            modified = "\u{25CF}", -- ●
            readonly = "\u{F023}", -- lock
            recording = "\u{F111}", -- filled circle
            explorer = "\u{F07C}", -- open folder
            dot = "\u{00B7}", -- ·
            divider = "\u{2502}", -- │
            clock = "\u{F0150}", -- clock face
        }

        local mode_short = {
            Normal = "NR",
            Insert = "IN",
            Visual = "VV",
            ["V-Line"] = "VL",
            ["V-Block"] = "VB",
            Select = "SL",
            ["S-Line"] = "SL",
            ["S-Block"] = "SB",
            Replace = "RP",
            Command = "CM",
            Prompt = "PR",
            Shell = "SH",
            Terminal = "TR",
        }

        -- No backgrounds: Ghostty's taller cells make filled cells look oversized
        local BAR = "StatuslineBar"

        -- Highlights derived from the colorscheme, reset when it changes
        local derived = {}
        local augroup = vim.api.nvim_create_augroup("statusline", { clear = true })

        vim.api.nvim_create_autocmd("ColorScheme", {
            group = augroup,
            callback = function() derived = {} end,
        })

        local function attrs(group) return vim.api.nvim_get_hl(0, { name = group, link = false }) end

        local function blend(color, towards, amount)
            local function channel(shift)
                local from = math.floor(color / shift) % 256
                local to = math.floor(towards / shift) % 256
                return math.floor(from + (to - from) * amount + 0.5)
            end

            return channel(65536) * 65536 + channel(256) * 256 + channel(1)
        end

        local function bg_of(group) return attrs(group).bg or attrs("Normal").bg end

        -- WCAG relative luminance
        local function luminance(color)
            local function channel(value)
                value = value / 255
                return value <= 0.03928 and value / 12.92 or ((value + 0.055) / 1.055) ^ 2.4
            end

            local r = channel(math.floor(color / 65536) % 256)
            local g = channel(math.floor(color / 256) % 256)
            local b = channel(color % 256)
            return 0.2126 * r + 0.7152 * g + 0.0722 * b
        end

        local function contrast(a, b)
            local high, low = luminance(a), luminance(b)
            if high < low then
                high, low = low, high
            end

            return (high + 0.05) / (low + 0.05)
        end

        local function fg_of(groups)
            for _, group in ipairs(groups) do
                local fg = attrs(group).fg
                if fg then
                    return fg
                end
            end
        end

        local accents = {
            branch = { "Constant" },
            added = { "GitSignsAdd", "Added", "DiffAdd" },
            changed = { "GitSignsChange", "Changed", "DiffChange" },
            removed = { "GitSignsDelete", "Removed", "DiffDelete" },
            error = { "DiagnosticError" },
            warn = { "DiagnosticWarn" },
            info = { "DiagnosticInfo" },
            hint = { "DiagnosticHint" },
            record = { "DiagnosticError" },
            dim = { "Comment" },
            title = { "DiagnosticWarn", "WarningMsg", "Special" },
        }

        local function ensure_base()
            if derived[BAR] then
                return
            end

            local normal = attrs("Normal")
            local bg = normal.bg or (vim.o.background == "dark" and 0x000000 or 0xFFFFFF)
            local fg = normal.fg or (vim.o.background == "dark" and 0xFFFFFF or 0x000000)

            vim.api.nvim_set_hl(0, BAR, { fg = blend(fg, bg, 0.45), bg = normal.bg })
            derived[BAR] = true
        end

        local function hl(accent, block)
            local name = ("Statusline_%s_%s"):format(accent, block)

            if not derived[name] then
                vim.api.nvim_set_hl(0, name, {
                    fg = fg_of(accents[accent]),
                    bg = bg_of(block),
                })
                derived[name] = true
            end

            return "%#" .. name .. "#"
        end

        local function block(group, content) return "%#" .. group .. "# " .. content .. "%#" .. group .. "# " end

        local function divider(group) return hl("dim", group) .. " " .. icon.divider .. " %#" .. group .. "#" end

        local function tint(group)
            local name = "StatuslineTint_" .. group

            if not derived[name] then
                vim.api.nvim_set_hl(0, name, { fg = bg_of(group), bg = bg_of(BAR) })
                derived[name] = true
            end

            return "%#" .. name .. "#"
        end

        local function label(group, content) return "%#" .. group .. "#" .. content .. "%#" .. BAR .. "#" end

        local function devicon()
            local ok, devicons = pcall(require, "nvim-web-devicons")
            if not ok then
                return nil
            end

            local glyph, color = devicons.get_icon_color(vim.fn.expand("%:t"), nil, { default = true })
            if not glyph or not color then
                return nil
            end

            return glyph, tonumber(color:sub(2), 16)
        end

        local function filetype_icon()
            local glyph, color = devicon()
            if not glyph then
                return ""
            end

            local name = ("StatuslineIcon_%06x"):format(color)
            if not derived[name] then
                vim.api.nvim_set_hl(0, name, { fg = color, bg = bg_of(BAR) })
                derived[name] = true
            end

            return "%#" .. name .. "#" .. glyph .. " "
        end

        -- Low-contrast language colors are blended towards the foreground
        local function title_group(color)
            color = color or fg_of(accents.title)

            local name = ("StatuslineTitle_%06x"):format(color)
            if not derived[name] then
                local normal = attrs("Normal")
                local bg = normal.bg or (vim.o.background == "dark" and 0x000000 or 0xFFFFFF)
                local fg = normal.fg or (vim.o.background == "dark" and 0xFFFFFF or 0x000000)

                local text, amount = color, 0
                while contrast(text, bg) < 3 and amount < 1 do
                    amount = amount + 0.1
                    text = blend(color, fg, amount)
                end

                vim.api.nvim_set_hl(0, name, {
                    fg = text,
                    bg = bg_of(BAR),
                    bold = true,
                })
                derived[name] = true
            end

            return name
        end

        local function search() return statusline.section_searchcount({ trunc_width = 75 }) end

        local function recording()
            local register = vim.fn.reg_recording()
            if register == "" then
                return ""
            end

            return hl("record", BAR) .. icon.recording .. " REC @" .. register
        end

        local function git(narrow)
            local out = {}
            local head = vim.b.gitsigns_head or vim.g.gitsigns_head

            if head and head ~= "" then
                out[#out + 1] = hl("branch", BAR) .. icon.branch .. " %#" .. BAR .. "#" .. head
            end

            local diff = vim.b.gitsigns_status_dict
            if diff and not narrow then
                for _, part in ipairs({ { "added", "+" }, { "changed", "~" }, { "removed", "-" } }) do
                    local count = diff[part[1]] or 0
                    if count > 0 then
                        out[#out + 1] = hl(part[1], BAR) .. part[2] .. count
                    end
                end
            end

            return table.concat(out, " ")
        end

        local function diagnostics()
            if not vim.diagnostic.is_enabled({ bufnr = 0 }) then
                return ""
            end

            local severity, counts, out = vim.diagnostic.severity, vim.diagnostic.count(0), {}

            for _, level in ipairs({ "error", "warn", "info", "hint" }) do
                local count = counts[severity[level:upper()]] or 0
                if count > 0 then
                    out[#out + 1] = hl(level, BAR) .. diagnostic[level] .. " " .. count
                end
            end

            return table.concat(out, " ")
        end

        -- LSP $/progress tasks; the spinner timer only runs while there are any
        local progress = {
            frames = {
                "\u{280B}",
                "\u{2819}",
                "\u{2839}",
                "\u{2838}",
                "\u{283C}",
                "\u{2834}",
                "\u{2826}",
                "\u{2827}",
                "\u{2807}",
                "\u{280F}",
            },
            tasks = {},
            frame = 1,
            seq = 0,
            timer = nil,
        }

        local function spin()
            if progress.timer then
                return
            end

            progress.timer = vim.uv.new_timer()
            progress.timer:start(
                0,
                100,
                vim.schedule_wrap(function()
                    progress.frame = progress.frame % #progress.frames + 1
                    vim.cmd("redrawstatus")
                end)
            )
        end

        local function stop_spinning()
            if not progress.timer then
                return
            end

            progress.timer:stop()
            progress.timer:close()
            progress.timer = nil
            vim.schedule(function() vim.cmd("redrawstatus") end)
        end

        local function ellipsis(text, width)
            if vim.fn.strdisplaywidth(text) <= width then
                return text
            end

            return vim.fn.strcharpart(text, 0, width - 1) .. "\u{2026}"
        end

        -- Newest task from a server attached to this buffer
        local function lsp_task()
            local attached = {}
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                attached[client.id] = true
            end

            local current
            for _, task in pairs(progress.tasks) do
                if attached[task.client] and (not current or task.seq > current.seq) then
                    current = task
                end
            end

            return current
        end

        local function fileinfo(narrow)
            local filetype = vim.bo.filetype
            if filetype == "" or vim.bo.buftype ~= "" then
                return ""
            end

            local out = { filetype_icon() .. "%#" .. BAR .. "#" .. filetype }

            if not narrow then
                local encoding = vim.bo.fileencoding
                if encoding ~= "" and encoding ~= "utf-8" then
                    out[#out + 1] = encoding
                end

                if vim.bo.fileformat ~= "unix" then
                    out[#out + 1] = vim.bo.fileformat == "dos" and "CRLF" or "CR"
                end
            end

            return table.concat(out, hl("dim", BAR) .. " " .. icon.dot .. " %#" .. BAR .. "#")
        end

        local function project_name()
            local name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return name == "" and "/" or name
        end

        local function title()
            if vim.bo.filetype == "NvimTree" then
                if statusline.is_truncated(20) then
                    return ""
                end

                return label(title_group(), icon.explorer .. " " .. project_name())
            end

            if statusline.is_truncated(40) then
                return ""
            end

            local glyph, color = devicon()
            local task = lsp_task()
            local content

            -- Spinner replaces the file icon while a server works
            local mark = task and progress.frames[progress.frame] or glyph

            if vim.bo.buftype == "terminal" then
                content = "%t"
            else
                local file = vim.fn.expand("%:t")
                if file == "" then
                    content = "[No Name]"
                else
                    content = (mark and mark ~= "" and mark .. " " or "") .. file
                end
            end

            if vim.bo.modified then
                content = content .. " " .. icon.modified
            end
            if vim.bo.readonly or not vim.bo.modifiable then
                content = content .. " " .. icon.readonly
            end

            if task and task.text ~= "" and not statusline.is_truncated(100) then
                content = content
                    .. " "
                    .. icon.dot
                    .. " "
                    -- Escape % for the statusline
                    .. (ellipsis(task.text, 40):gsub("%%", "%%%%"))
            end

            return label(title_group(color), content)
        end

        local function clock() return hl("dim", BAR) .. icon.clock .. " %#" .. BAR .. "#" .. os.date("%H:%M") end

        local function active()
            ensure_base()

            local mode, mode_hl = statusline.section_mode({})
            -- Unknown modes return an already-wrapped group name
            if mode_hl:find("%W") then
                mode_hl = "MiniStatuslineModeOther"
            end

            local narrow = statusline.is_truncated(80)

            local gutter = "%#" .. BAR .. "# "

            if vim.bo.filetype == "NvimTree" then
                return "%=" .. title() .. "%="
            end

            local parts = {
                gutter,
                tint(mode_hl) .. (mode_short[mode] or mode:sub(1, 2):upper()),
            }

            local devinfo = table.concat(
                vim.tbl_filter(function(section) return section ~= "" end, {
                    recording(),
                    search(),
                    git(narrow),
                    diagnostics(),
                }),
                divider(BAR)
            )

            if devinfo ~= "" then
                parts[#parts + 1] = block(BAR, devinfo)
            end

            parts[#parts + 1] = "%<%="

            local center = title()
            if center ~= "" then
                parts[#parts + 1] = center
                parts[#parts + 1] = "%="
            end

            local right = { fileinfo(narrow), clock() }
            parts[#parts + 1] =
                block(BAR, table.concat(vim.tbl_filter(function(x) return x ~= "" end, right), divider(BAR)))
            parts[#parts + 1] = gutter

            return table.concat(parts)
        end

        local function inactive()
            local content

            if vim.bo.filetype == "NvimTree" then
                content = icon.explorer .. " " .. project_name()
            elseif vim.bo.buftype == "terminal" then
                content = "%t"
            else
                local glyph = devicon()
                local file = vim.fn.expand("%:t")
                content = file == "" and "[No Name]" or ((glyph and glyph ~= "" and glyph .. " " or "") .. file)
            end

            return "%#" .. BAR .. "#%=" .. hl("dim", BAR) .. content .. "%#" .. BAR .. "#%="
        end

        statusline.setup({
            content = { active = active, inactive = inactive },
        })

        -- Keep the clock moving while idle
        local ticker = vim.uv.new_timer()
        ticker:start(
            30000,
            30000,
            vim.schedule_wrap(function()
                if vim.o.laststatus > 0 then
                    vim.cmd("redrawstatus")
                end
            end)
        )

        vim.api.nvim_create_autocmd("VimLeavePre", {
            group = augroup,
            callback = function()
                if not ticker:is_closing() then
                    ticker:close()
                end

                if progress.timer then
                    progress.timer:stop()
                    progress.timer:close()
                    progress.timer = nil
                end
            end,
        })

        vim.api.nvim_create_autocmd("LspProgress", {
            group = augroup,
            callback = function(args)
                local params = args.data.params or args.data.result
                if not params then
                    return
                end

                local value = params.value or {}
                local key = args.data.client_id .. ":" .. tostring(params.token)

                if value.kind == "end" then
                    progress.tasks[key] = nil
                else
                    local text = value.title or ""
                    if value.message and value.message ~= "" then
                        text = text ~= "" and (text .. " " .. value.message) or value.message
                    end
                    if value.percentage then
                        text = text .. (" %d%%"):format(value.percentage)
                    end

                    progress.seq = progress.seq + 1
                    progress.tasks[key] = { client = args.data.client_id, text = text, seq = progress.seq }
                end

                if next(progress.tasks) then
                    spin()
                else
                    stop_spinning()
                end
            end,
        })

        -- A detached server never sends "end"
        vim.api.nvim_create_autocmd("LspDetach", {
            group = augroup,
            callback = function(args)
                for key, task in pairs(progress.tasks) do
                    if task.client == args.data.client_id then
                        progress.tasks[key] = nil
                    end
                end

                if not next(progress.tasks) then
                    stop_spinning()
                end
            end,
        })

        vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
            group = augroup,
            callback = function()
                vim.schedule(function() vim.cmd("redrawstatus") end)
            end,
        })

        -- Scheduled: RecordingLeave fires before the register clears
        vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave", "DiagnosticChanged" }, {
            group = augroup,
            callback = function()
                vim.schedule(function() vim.cmd("redrawstatus") end)
            end,
        })
    end,
}
