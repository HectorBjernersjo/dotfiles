return {
    { "tpope/vim-dadbod" },
    { "kristijanhusak/vim-dadbod-completion" },
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = {
            "tpope/vim-dadbod",
        },
        config = function()
            require('keymaps').dadbod()
        end,
    },
}
