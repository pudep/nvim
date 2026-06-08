return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            require("nvim-treesitter").setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            require("nvim-treesitter")
                .install({
                    "lua", "javascript", "zig", "go",
                    "python", "html", "css",
                })
                :wait(300000)

            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local ok = pcall(vim.treesitter.start)
                    if not ok then return end

                    local wo = vim.wo[0][0]
                    wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    wo.foldmethod = "expr"
                    wo.foldlevel = 99
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
}
