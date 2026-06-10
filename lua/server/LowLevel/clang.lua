vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index", -- persist index to disk across restarts
        "--clang-tidy", -- enable clang-tidy diagnostics
        "--completion-style=detailed", -- include param names/types in completion
        "--header-insertion=iwyu", -- insert headers per IWYU policy
        "--header-insertion-decorators",
        "--all-scopes-completion", -- complete symbols from all scopes
        "--cross-file-rename", -- support renames across files
        "--fallback-style=LLVM", -- style when no .clang-format is present
        "--pch-storage=disk", -- disk is more consistent for C++ template-heavy TUs
        "--ranking-model=decision_forest", -- faster ranking for completions
        "-j=4", -- background indexing threads (tune to CPU)
        "--log=error", -- suppress verbose clangd stdout noise
        "--enable-config", -- honour per-project .clangd config files
        "--offset-encoding=utf-16", -- matches Neovim's default LSP encoding
    },

    filetypes = {
        "c",
        "cpp",
        "objc",
        "objcpp",
        "cuda",
        "proto",
    },

    root_markers = {
        "compile_commands.json",
        "compile_flags.txt",
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "CMakeLists.txt",
        "Makefile",
        "meson.build",
        "build.ninja",
        ".git",
    },

    capabilities = (function()
        local caps = vim.lsp.protocol.make_client_capabilities()
        caps.textDocument.completion.completionItem.snippetSupport = true
        caps.textDocument.completion.completionItem.resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
        }
        return caps
    end)(),

    settings = {},
})

vim.lsp.enable("clangd")

