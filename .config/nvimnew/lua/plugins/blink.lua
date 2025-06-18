return {
    {
        'saghen/blink.cmp',
        -- -- optional: provides snippets for the snippet source
        -- dependencies = { 'rafamadriz/friendly-snippets' },

        opts = {
            keymap = { preset = 'default' },

            appearance = {
                nerd_font_variant = 'mono'
            },

            completion = { documentation = { auto_show = false } },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                per_filetype = {
                    sql = { 'snippets', 'dadbod', 'buffer' },
                },
                providers = {
                    dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
                },
            },


            fuzzy = { implementation = "lua" },
            cmdline = {
                keymap = { preset = 'inherit' },
                completion = { menu = { auto_show = true } },
            },
        },
        opts_extend = { "sources.default" }
    }
}
