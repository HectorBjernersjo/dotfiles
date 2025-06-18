M = {}

M.global = function()
    vim.keymap.set("n", "<leader>a", "ggVGy", { noremap = true, silent = true })
    vim.keymap.set("n", "<leader>v", vim.cmd.sp)
    vim.keymap.set("n", "<leader>h", vim.cmd.vsp)
    vim.keymap.set("n", "<C-n>", vim.cmd.bnext)
    vim.keymap.set("n", "<C-p>", vim.cmd.bprevious)

    vim.keymap.set("i", "<C-d>", "<Del>")

    vim.keymap.set("v", "<S-J>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
    vim.keymap.set("v", "<S-K>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

    vim.keymap.set("n", "<leader>p", '"d_P')

    -- Set highlight on search, but clear on pressing <Esc> in normal mode
    vim.opt.hlsearch = true
    vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

    -- Diagnostic keymaps
    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
end


M.oil = function()
    vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open directory in oil" })
end

M.undotree = function()
    vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
end

M.vim_tmux_navigator = function()
    vim.keymap.set({ "n", "v", "i" }, "<C-h>", "<cmd>TmuxNavigateLeft<CR>")
    vim.keymap.set({ "n", "v", "i" }, "<C-l>", "<cmd>TmuxNavigateRight<CR>")
    vim.keymap.set({ "n", "v", "i" }, "<C-j>", "<cmd>TmuxNavigateDown<CR>")
    vim.keymap.set({ "n", "v", "i" }, "<C-k>", "<cmd>TmuxNavigateUp<CR>")
end

M.lsp = function(bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Overtaken by snacks maybe will come back
    -- km("n", "gd", vim.lsp.buf.definition, opts)
    -- km("n", "gD", vim.lsp.buf.declaration, opts)
    -- km("n", "gr", vim.lsp.buf.references, opts)
    -- km("n", "gi", vim.lsp.buf.implementation, opts)
    -- km("n", "gy", vim.lsp.buf.type_definition, opts)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
end

M.neogit = function()
    vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>")

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "DiffviewFiles",
        callback = function()
            vim.keymap.set("n", "q", ":DiffviewClose<CR>", { buffer = true, desc = "Diffview: Open" })
        end,
    })
end

M.dadbod = function()
    vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<CR>")
end

M.snacks = {
    { "<leader>ps", function() Snacks.picker.smart() end,                                                         desc = "Smart Find Files" },
    { "<leader>pf", function() Snacks.picker.files() end,                                                         desc = "Find Files" },
    { "<leader>pr", function() Snacks.picker.recent() end,                                                        desc = "Recent" },
    { "<leader>pg", function() Snacks.picker.grep() end,                                                          desc = "Grep" },
    { "<leader>pa", function() Snacks.picker.git_status() end,                                                    desc = "Git Status" },
    { "<leader>ph", function() require("snacks").picker.files({ sources = { files = { hidden = true }, }, }) end, desc = "Find Files (Including Hidden)", },

    { "gd",         function() Snacks.picker.lsp_definitions() end,                                               desc = "Goto Definition" },
    { "gD",         function() Snacks.picker.lsp_declarations() end,                                              desc = "Goto Declaration" },
    { "gr",         function() Snacks.picker.lsp_references() end,                                                nowait = true,                          desc = "References" },
    { "gi",         function() Snacks.picker.lsp_implementations() end,                                           desc = "Goto Implementation" },
    { "gy",         function() Snacks.picker.lsp_type_definitions() end,                                          desc = "Goto T[y]pe Definition" },

    { "<leader>:",  function() Snacks.picker.command_history() end,                                               desc = "Command History" },

    { "<leader>gB", function() Snacks.gitbrowse() end,                                                            desc = "Git Browse",                    mode = { "n", "v" } },
    { "<leader>un", function() Snacks.notifier.hide() end,                                                        desc = "Dismiss All Notifications" },
    { "<leader>n",  function() Snacks.notifier.show_history() end,                                                desc = "Notification History" },
    { "<leader>.",  function() Snacks.scratch() end,                                                              desc = "Toggle Scratch Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end,                                                   desc = "Rename File" },

    { "<leader>pc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end,                       desc = "Find Config File" },
    { "<leader>pp", function() Snacks.picker.projects() end,                                                      desc = "Projects" },
    { "<leader>si", function() Snacks.picker.icons() end,                                                         desc = "Icons" },
    { "<leader>pe", function() Snacks.picker.resume() end,                                                        desc = "Resume" },
    { "<leader>fb", function() Snacks.picker.buffers() end,                                                       desc = "Buffers" },
    { "<leader>gb", function() Snacks.picker.grep_buffers() end,                                                  desc = "Grep Open Buffers" },
    { "<leader>gw", function() Snacks.picker.grep_word() end,                                                     desc = "Visual selection or word",      mode = { "n", "x" } },
    { "<leader>pd", function() Snacks.picker.diagnostics() end,                                                   desc = "Diagnostics" },
}

M.harpoon = function()
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    vim.keymap.set("n", "<leader>d", mark.add_file, { desc = "Harpoon Add File" })
    vim.keymap.set("n", "<leader>l", ui.toggle_quick_menu, { desc = "Harpoon Toggle Menu" })

    vim.keymap.set("n", "<leader>1", function() ui.nav_file(1) end, { desc = "Harpoon Goto File 1" })
    vim.keymap.set("n", "<leader>2", function() ui.nav_file(2) end, { desc = "Harpoon Goto File 2" })
    vim.keymap.set("n", "<leader>3", function() ui.nav_file(3) end, { desc = "Harpoon Goto File 3" })
    vim.keymap.set("n", "<leader>4", function() ui.nav_file(4) end, { desc = "Harpoon Goto File 4" })
    vim.keymap.set("n", "<leader>5", function() ui.nav_file(5) end, { desc = "Harpoon Goto File 5" })
    vim.keymap.set("n", "<leader>6", function() ui.nav_file(6) end, { desc = "Harpoon Goto File 6" })
end

M.mini_surrond = {
    add = 'sa',            -- Add surrounding in Normal and Visual modes
    delete = 'sd',         -- Delete surrounding
    find = 'sf',           -- Find surrounding (to the right)
    find_left = 'sF',      -- Find surrounding (to the left)
    highlight = 'sh',      -- Highlight surrounding
    replace = 'sr',        -- Replace surrounding
    update_n_lines = 'sn', -- Update `n_lines`

    suffix_last = 'l',     -- Suffix to search with "prev" method
    suffix_next = 'n',     -- Suffix to search with "next" method

}


-- Unused
M.telescope = function()
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ph", function() builtin.find_files({ hidden = true }) end,
        { desc = "[S]earch [F]iles (hidden)" })
    vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>pg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>pe", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "[ ] Find existing buffers" })

    vim.keymap.set("n", "<leader>pk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
    vim.keymap.set("n", "<leader>ps", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>pd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
    vim.keymap.set("n", "<leader>pr", builtin.resume, { desc = "[S]earch [R]esume" })
end

M.global()

return M
