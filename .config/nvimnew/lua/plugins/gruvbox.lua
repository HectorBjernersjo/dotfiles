return {
    {
        "sainnhe/gruvbox-material",
        config = function()
            vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b" })
            vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#37222c" })
            vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f2231" })
            vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })
            vim.cmd [[colorscheme gruvbox-material]]
        end
    },
}
