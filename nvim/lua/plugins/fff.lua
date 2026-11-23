-- Registered at require time: config() runs after the install event has fired
vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("fff-binary", { clear = true }),
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name ~= "fff" or (kind ~= "install" and kind ~= "update") then
            return
        end
        if not ev.data.active then
            vim.cmd.packadd("fff")
        end
        require("fff.download").download_or_build_binary()
    end,
})

return {

    plugin = {
        src = "https://github.com/dmtrKovalenko/fff",
    },

    config = function()
        local function ensure_binary()
            local download = require("fff.download")
            local binary = download.get_binary_path()
            if vim.fn.filereadable(binary) == 1 then
                return
            end

            -- Exact commit tags 404 when HEAD is ahead of the last published nightly,
            -- and this machine has no rustup to fall back on.
            pcall(download.download_or_build_binary)
            if vim.fn.filereadable(binary) == 1 then
                return
            end

            local repo = vim.fn.fnamemodify(binary, ":h:h:h")
            local tag = vim.trim(vim.fn.system({ "git", "-C", repo, "describe", "--tags", "--abbrev=0" }))
            if vim.v.shell_error ~= 0 or tag == "" then
                tag = "nightly"
            end

            local system = require("fff.utils.system")
            local url = string.format(
                "https://github.com/dmtrKovalenko/fff/releases/download/%s/%s.%s",
                tag,
                system.get_triple(),
                system.get_lib_extension()
            )

            vim.fn.mkdir(vim.fn.fnamemodify(binary, ":h"), "p")
            local result = vim.system({
                "curl",
                "--fail",
                "--location",
                "--silent",
                "--show-error",
                "--output",
                binary,
                url,
            }):wait()
            if result.code ~= 0 then
                vim.notify("fff: failed to download " .. url .. "\n" .. (result.stderr or ""), vim.log.levels.ERROR)
            end
        end

        ensure_binary()

        require("fff").setup({
            prompt = "\u{F105} ",
            prompt_vim_mode = true,
            mappings = {
                i = { ["jj"] = "<Esc>" },
            },
            layout = {
                border = "single",
            },
            -- Default `Title` has no background, leaving a see-through gap in the border
            hl = { title = "FloatTitle" },
            keymaps = {
                -- Replaces the defaults, so they're repeated here
                move_down = { "<Down>", "<C-n>", "<C-j>" },
                move_up = { "<Up>", "<C-p>", "<C-k>" },
            },
        })

        local map = function(lhs, fn, desc) vim.keymap.set("n", lhs, fn, { desc = desc }) end

        map("<leader>ff", function() require("fff").find_files() end, "Find files")
        map("<leader>fw", function() require("fff").live_grep() end, "Live grep")
        map("<leader>fc", function() require("fff").live_grep_under_cursor() end, "Grep word under cursor")
    end,
}
