return {

    plugin = {
        src = "https://github.com/folke/snacks.nvim",
    },

    config = function()
        require("snacks").setup({
            picker = {
                enabled = true,
                actions = {
                    trouble_open = function(...)
                        return require("trouble.sources.snacks").actions.trouble_open.action(...)
                    end,
                },
                win = {
                    input = {
                        keys = {
                            ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
                        },
                    },
                },
            },
            indent = {
                enabled = true,
                -- ┊ and ╎ break up in Ghostty's taller cells
                indent = { char = "┆" },
                scope = { char = "┆" },
                animate = { enabled = false },
            },
            lazygit = { enabled = true },
            notifier = { enabled = true },
            words = { enabled = true },
            bigfile = { enabled = true },
            -- Ghostty's kitty graphics protocol; tmux needs allow-passthrough
            image = { enabled = true },
            explorer = { enabled = false },
        })

        -- Let previews (fff, snacks picker) render formats beyond snacks' `formats` list.
        -- Opening a file is driven by `formats`, not this check, so a .svg still opens as editable XML.
        local preview_only = { svg = true, ico = true, tif = true, eps = true, ps = true }
        local supports_file = Snacks.image.supports_file
        Snacks.image.supports_file = function(file)
            return preview_only[vim.fn.fnamemodify(file, ":e"):lower()] or supports_file(file)
        end

        -- snacks converts with `magick`, whose built-in SVG renderer mangles masks, filters and
        -- blend modes. Pre-render local SVGs with librsvg instead, cached by path and mtime.
        local image_new = Snacks.image.image.new
        Snacks.image.image.new = function(src)
            local stat = vim.fn.executable("rsvg-convert") == 1
                and src:lower():match("%.svg$")
                and vim.uv.fs_stat(src)
            if stat then
                local dir = vim.fn.stdpath("cache") .. "/svg-preview"
                local png = string.format("%s/%s.png", dir, vim.fn.sha256(src .. stat.mtime.sec .. stat.size))
                if not vim.uv.fs_stat(png) then
                    vim.fn.mkdir(dir, "p")
                    vim.system({ "rsvg-convert", "--zoom", "2", "--output", png, src }):wait()
                end
                if vim.uv.fs_stat(png) then
                    src = png
                end
            end
            return image_new(src)
        end

        -- The theme's guide color is nearly invisible
        local function guide_colors()
            vim.api.nvim_set_hl(0, "SnacksIndent", { link = "Whitespace" })
            vim.api.nvim_set_hl(0, "SnacksIndentScope", { link = "LineNr" })
        end
        guide_colors()
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("snacks-guide-colors", { clear = true }),
            callback = guide_colors,
        })

        local picker = require("snacks").picker
        local map = function(lhs, fn, desc) vim.keymap.set("n", lhs, fn, { desc = desc }) end

        -- <leader>ff/fw are in fff.lua
        map("<leader>fa", function() picker.files({ hidden = true, ignored = true }) end, "Find all files")
        map("<leader>fb", function() picker.buffers() end, "Find buffers")
        map("<leader>fo", function() picker.recent() end, "Recent files")
        map("<leader>fh", function() picker.help() end, "Help pages")
        map("<leader>fz", function() picker.lines() end, "Search current buffer")
        map("<leader>fk", function() picker.keymaps() end, "Keymaps")
        map("<leader>fd", function() picker.diagnostics() end, "Diagnostics")
        map("<leader>fr", function() picker.resume() end, "Resume last picker")

        map("<leader>gt", function() picker.git_status() end, "Git status")
        map("<leader>cm", function() picker.git_log() end, "Git commits")
        map("<leader>gg", function() Snacks.lazygit() end, "Lazygit")

        map("<leader>fn", function() Snacks.notifier.show_history() end, "Notification history")

        -- SVG isn't in snacks' image formats (it opens as editable XML), so swap this window
        -- between the XML and a rendered preview buffer
        local function toggle_svg_preview(buf)
            local source = vim.b[buf].svg_source
            if source then
                if vim.api.nvim_buf_is_valid(source) then
                    -- Remembered so the auto-preview below doesn't flip it straight back
                    vim.b[source].svg_show_source = true
                    vim.api.nvim_win_set_buf(0, source)
                end
                return
            end
            vim.b[buf].svg_show_source = false
            local preview = vim.api.nvim_create_buf(false, true)
            vim.bo[preview].bufhidden = "wipe"
            vim.b[preview].svg_source = buf
            vim.api.nvim_win_set_buf(0, preview)
            -- buf.attach rejects extensions outside `formats`; placement.new does the rendering itself
            Snacks.image.placement.new(preview, vim.api.nvim_buf_get_name(buf), { conceal = true, auto_resize = true })
        end

        -- Open SVGs as the rendered image by default; <leader>vi switches to the XML
        vim.api.nvim_create_autocmd("BufWinEnter", {
            group = vim.api.nvim_create_augroup("svg-auto-preview", { clear = true }),
            pattern = "*.svg",
            callback = function(ev)
                local win = vim.api.nvim_get_current_win()
                -- Skip picker/float previews and buffers switched to XML on purpose
                if vim.b[ev.buf].svg_show_source or vim.api.nvim_win_get_config(win).relative ~= ""
                    or vim.bo[ev.buf].buftype ~= "" or not Snacks.image.supports_terminal() then
                    return
                end
                vim.schedule(function()
                    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == ev.buf then
                        vim.api.nvim_win_call(win, function() toggle_svg_preview(ev.buf) end)
                    end
                end)
            end,
        })

        -- snacks.image has no toggle; hide/show this buffer's images (image file or doc images)
        map("<leader>vi", function()
            local buf = vim.api.nvim_get_current_buf()
            if vim.bo[buf].filetype == "svg" or vim.b[buf].svg_source then
                return toggle_svg_preview(buf)
            end
            local image_file = vim.bo[buf].filetype == "image"
            if vim.b[buf].images_hidden then
                vim.b[buf].images_hidden = false
                if image_file then
                    Snacks.image.buf.attach(buf)
                else
                    vim.b[buf].snacks_image_attached = false
                    Snacks.image.doc.attach(buf)
                end
                vim.notify("Images on")
            else
                vim.b[buf].images_hidden = true
                pcall(vim.api.nvim_del_augroup_by_name, "snacks.image.inline." .. buf)
                Snacks.image.placement.clean(buf)
                vim.notify("Images off")
            end
        end, "Toggle images")

        map("]r", function() Snacks.words.jump(1) end, "Next reference")
        map("[r", function() Snacks.words.jump(-1) end, "Previous reference")

        map("grr", function() picker.lsp_references() end, "References")
        map("<leader>fs", function() picker.lsp_symbols() end, "Document symbols")
    end,
}
