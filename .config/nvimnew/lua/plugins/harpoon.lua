return {
    {
        "ThePrimeagen/harpoon",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("harpoon").setup({
                global_settings = {
                    save_on_toggle = false,
                    save_on_change = true,
                    excluded_filetypes = { "harpoon" },
                    mark_branch = true,
                },
            })

            -- Use telescope
            require("telescope").load_extension("harpoon")
            require('keymaps').harpoon()
        end,
    },
}
