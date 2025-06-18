return {
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        opts = {},
        config = function(_, opts)
            local on_attach = function(client, bufnr)
                require('keymaps').lsp(bufnr)
            end

            vim.lsp.config("roslyn", {
                on_attach = on_attach,
                settings = {
                    ["csharp|code_lens"] = {
                        dotnet_enable_references_code_lens = true,
                    },
                },
            })

            require("roslyn").setup(opts)
        end,
    }
}
