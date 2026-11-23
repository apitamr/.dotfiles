return {

    plugin = {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
    },

    config = function()
        -- Injection-only parsers; everything else installs on demand
        require("nvim-treesitter").install({
            "comment",
            "regex",
            "printf",
            "doxygen",
            "luadoc",
            "luap",
            "jsdoc",
        })

        -- ]] / [[ jump between named functions, using treesitter instead of column-1 braces.
        -- Anonymous functions count only when bound to a name.
        local BINDS_A_NAME = {
            variable_declarator = true, -- const handler = () => {}
            assignment_statement = true, -- lua: M.setup = function() end
            assignment = true, -- python
            field = true, -- lua table: config = function() end
            pair = true, -- js object literal: { onClick: function() {} }
        }

        local function is_named_function(node)
            local kind = node:type()
            if not (kind:find("function") or kind:find("method") or kind:find("class")) then
                return false
            end
            if kind:find("_call$") then
                return false
            end

            local declares = kind:find("_declaration$") or kind:find("_definition$") or kind:find("_item$")
            if declares and node:field("name")[1] ~= nil then
                return true
            end

            local parent = node:parent()
            return parent ~= nil and BINDS_A_NAME[parent:type()] == true
        end

        -- Name is checked too: reused buffer numbers can repeat a changedtick
        local cache = {}

        local function declaration_starts()
            local buf = vim.api.nvim_get_current_buf()
            local tick = vim.b[buf].changedtick
            local name = vim.api.nvim_buf_get_name(buf)
            local hit = cache[buf]
            if hit and hit.tick == tick and hit.name == name then
                return hit.starts
            end

            local ok, parser = pcall(vim.treesitter.get_parser)
            if not ok or parser == nil then
                return {}
            end

            local tree = parser:parse()[1]
            if tree == nil then
                return {}
            end

            local starts, seen = {}, {}

            local function walk(node)
                if is_named_function(node) then
                    local row, col = node:range()
                    if not seen[row] then
                        seen[row] = true
                        starts[#starts + 1] = { row + 1, col }
                    end
                end
                for child in node:iter_children() do
                    walk(child)
                end
            end

            walk(tree:root())
            table.sort(starts, function(a, b) return a[1] < b[1] end)

            cache[buf] = { tick = tick, name = name, starts = starts }
            return starts
        end

        vim.api.nvim_create_autocmd("BufWipeout", {
            group = vim.api.nvim_create_augroup("treesitter-motion-cache", { clear = true }),
            callback = function(args) cache[args.buf] = nil end,
        })

        local function jump(step)
            local starts = declaration_starts()
            local line = vim.api.nvim_win_get_cursor(0)[1]

            local target
            if step > 0 then
                for _, pos in ipairs(starts) do
                    if pos[1] > line then
                        target = pos
                        break
                    end
                end
            else
                for i = #starts, 1, -1 do
                    if starts[i][1] < line then
                        target = starts[i]
                        break
                    end
                end
            end

            if target == nil then
                return
            end

            vim.cmd.normal({ "m`", bang = true })
            vim.api.nvim_win_set_cursor(0, target)
            vim.cmd.normal({ "zv", bang = true })
        end

        -- Buffer-local, from FileType, to override ftplugin ]] / [[ maps
        local function set_motions(buf)
            vim.keymap.set({ "n", "x" }, "]]", function() jump(1) end, { buffer = buf, desc = "Next function" })
            vim.keymap.set({ "n", "x" }, "[[", function() jump(-1) end, { buffer = buf, desc = "Previous function" })
        end

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter-motions", { clear = true }),
            callback = function(args) set_motions(args.buf) end,
        })

        set_motions(0)

        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("treesitter-start", { clear = true }),
            callback = function(args)
                local ft = vim.bo[args.buf].filetype
                local lang = vim.treesitter.language.get_lang(ft) or ft
                local ts_config = require("nvim-treesitter.config")

                if vim.tbl_contains(ts_config.get_installed(), lang) then
                    pcall(vim.treesitter.start, args.buf)
                    return
                end

                if not vim.tbl_contains(ts_config.get_available(), lang) then
                    return
                end

                require("nvim-treesitter").install({ lang }, { summary = false }):await(function(err)
                    if err then
                        return
                    end
                    vim.schedule(function()
                        if vim.api.nvim_buf_is_valid(args.buf) then
                            pcall(vim.treesitter.start, args.buf)
                        end
                    end)
                end)
            end,
        })
    end,
}
