vim.lsp.start({
    name = "clangd",
    cmd = { "clangd" },
    root_dir = vim.fn.getcwd(),
})
