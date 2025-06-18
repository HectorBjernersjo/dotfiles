return {
    {
        'mason-org/mason.nvim',
        config = function()
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                },
            })
        end
    },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                "lua_ls",
                "ts_ls",
            },
            automatic_enable = false
        }
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp"
        },
        config = function()
            local lspconfig = require('lspconfig')

            local on_attach = function(client, bufnr)
                require('keymaps').lsp(bufnr)
            end

            local capabilities = require('blink.cmp').get_lsp_capabilities()

            lspconfig.lua_ls.setup({
                on_attach = on_attach
            })

            lspconfig.ts_ls.setup({
                on_attach = on_attach
            })

            require('scripts.format_on_save')
        end
    }
}
