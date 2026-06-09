vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--clang-tidy=false",
        "--background-index=false",
        "--log=error",
        "--completion-style=detailed",
        "--fallback-style=llvm",
        "--header-insertion=iwyu",
        "-j=1",
        "--pch-storage=memory",
    },
    flags = {
        debounce_text_changes = 150,
    },
    filetypes = { "c", "cpp" },
    init_options = {
        fallbackFlags = { "-std=c++20" },
    },
})

vim.lsp.enable("clangd")
