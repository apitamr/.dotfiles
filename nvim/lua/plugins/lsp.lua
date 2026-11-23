return {

    plugin = {
        { src = "https://github.com/neovim/nvim-lspconfig" },
    },

    config = function()
        local glyph = require("icons").diagnostic
        local icons = {
            [vim.diagnostic.severity.ERROR] = glyph.error,
            [vim.diagnostic.severity.WARN] = glyph.warn,
            [vim.diagnostic.severity.INFO] = glyph.info,
            [vim.diagnostic.severity.HINT] = glyph.hint,
        }

        vim.diagnostic.config({
            severity_sort = true,
            signs = { text = icons },
            virtual_text = {
                spacing = 2,
                prefix = "●",
                source = "if_many",
            },
            float = {
                border = "single",
                source = "if_many",
            },
        })

        vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

        -- Can't wait for blink's deferred setup: a server may attach before VimEnter
        vim.lsp.config("*", {
            capabilities = require("blink.cmp").get_lsp_capabilities(),
        })

        -- Neovim runtime for lua_ls, unless the project has its own .luarc.json
        vim.lsp.config("lua_ls", {
            on_init = function(client)
                local folder = client.workspace_folders and client.workspace_folders[1]
                if folder then
                    local path = folder.name
                    if
                        path ~= vim.fn.stdpath("config")
                        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
                    then
                        return
                    end
                end
                client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
                    runtime = { version = "LuaJIT", path = { "lua/?.lua", "lua/?/init.lua" } },
                    workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
                })
            end,
            settings = { Lua = {} },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-keymaps", { clear = true }),
            callback = function(args)
                local opts = { buffer = args.buf }
                vim.keymap.set(
                    { "n", "v" },
                    "<leader>ca",
                    vim.lsp.buf.code_action,
                    vim.tbl_extend("force", opts, { desc = "Code action" })
                )
                vim.keymap.set(
                    "n",
                    "<leader>rn",
                    vim.lsp.buf.rename,
                    vim.tbl_extend("force", opts, { desc = "Rename symbol" })
                )
                vim.keymap.set(
                    "n",
                    "gd",
                    vim.lsp.buf.definition,
                    vim.tbl_extend("force", opts, { desc = "Go to definition" })
                )
                vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
            end,
        })

        -- jsonls warns about trailing commas even in jsonc
        local TRAILING_COMMA = 519 -- vscode-json-languageservice ErrorCode.TrailingComma
        local function keep_in(bufnr)
            return function(diagnostic) return diagnostic.code ~= TRAILING_COMMA or vim.bo[bufnr].filetype ~= "jsonc" end
        end

        vim.lsp.config("jsonls", {
            handlers = {
                ["textDocument/publishDiagnostics"] = function(err, result, ctx)
                    if not (result and result.diagnostics) then
                        return
                    end
                    result.diagnostics = vim.tbl_filter(keep_in(vim.uri_to_bufnr(result.uri)), result.diagnostics)
                    return vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
                end,
                ["textDocument/diagnostic"] = function(err, result, ctx)
                    if result and result.items then
                        result.items = vim.tbl_filter(keep_in(ctx.bufnr), result.items)
                    end
                    return vim.lsp.diagnostic.on_diagnostic(err, result, ctx)
                end,
            },
        })

        vim.lsp.enable({
            "lua_ls",
            "bashls",
            "clangd",
            "gopls",
            "rust_analyzer",
            "zls",
            "vtsls",
            "oxlint",
            "tailwindcss",
            "html",
            "cssls",
            "jsonls",
            "yamlls",
            "dockerls",
            "docker_compose_language_service",
        })
    end,
}
