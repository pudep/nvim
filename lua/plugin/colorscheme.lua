return {
    {
        "Mofiqul/vscode.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("vscode").setup({
                transparent = false,
                italic_comments = false, -- Changed from true to false
                underline_links = true,
                disable_nvimtree_bg = true,
            })
            vim.cmd.colorscheme("vscode")
        end,
    },
}
