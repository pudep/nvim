return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            cache = true,
            styles = {
                comments = { italic = false },
                keywords = { italic = false },
                functions = { italic = false },
                variables = { italic = false },
            },
            terminal_colors = true,
            sidebars = "dark",
            floats = "dark",
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight")
        end,
    },
}
