return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                columns = { "icon" },
                view_options = {
                    show_hidden = true,
                },
            })
            require('keymaps').oil()
        end,
    },
}
