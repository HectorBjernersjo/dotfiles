return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'c_sharp', 'lua', 'typescript', 'javascript', 'html', 'python' },
                auto_install = true,
                highlight = {
                    enable = true,
                }
            })
        end
    }
}
