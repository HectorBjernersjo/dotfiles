vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormatting", {}),
    callback = function()
        vim.lsp.buf.format()
    end,
    desc = "Format on save (LSP)",
})
