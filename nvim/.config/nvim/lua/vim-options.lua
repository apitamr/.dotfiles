do
    vim.loader.enable()

    -- Must be set before plugins load
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    vim.g.have_nerd_font = true

    vim.o.number = true
    vim.o.mouse = "a"
    vim.o.showmode = false

    -- Scheduled because setting clipboard can slow startup
    vim.schedule(function() vim.o.clipboard = "unnamedplus" end)

    vim.o.shiftwidth = 4
    vim.o.tabstop = 4
    vim.o.expandtab = true

    vim.o.breakindent = true
    vim.o.undofile = true
    vim.o.ignorecase = true
    vim.o.smartcase = true
    vim.o.signcolumn = "yes"
    vim.o.updatetime = 250
    vim.o.timeoutlen = 300
    vim.o.splitright = true
    vim.o.splitbelow = true

    vim.o.list = true
    vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

    vim.opt.fillchars = {
        eob = " ",
        fold = " ",
        foldopen = "\u{EAB4}", -- chevron-down
        foldclose = "\u{EAB6}", -- chevron-right
        foldsep = " ",
        foldinner = " ",
    }

    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldtext = ""
    vim.o.foldcolumn = "1"

    vim.o.inccommand = "split"
    vim.o.cursorline = true
    vim.o.scrolloff = 10
    vim.o.confirm = true
end
