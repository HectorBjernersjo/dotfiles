return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            animate = { enabled = false },
            bigfile = { enabled = true },
            bufdelete = { enabled = false },
            dashboard = { enabled = false },
            debug = { enabled = false },
            dim = { enabled = false },
            explorer = { enabled = false },
            git = { enabled = true },
            gitbrowse = { enabled = false },
            image = { enabled = false },
            indent = { enabled = false },
            input = { enabled = false },
            layout = { enabled = false },
            lazygit = { enabled = false },
            notifier = { enabled = false },
            notify = { enabled = false },
            picker = {
                enabled = true,
                layout = {
                    preset = 'telescope'
                },
            },
            profiler = { enabled = false },
            quickfile = { enabled = false },
            rename = { enabled = false },
            scope = { enabled = false },
            scratch = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            terminal = { enabled = false },
            toggle = { enabled = false },
            util = { enabled = false },
            win = { enabled = false },
            words = { enabled = false },
            zen = { enabled = true }
        },
        keys = require('keymaps').snacks,
    }
}
