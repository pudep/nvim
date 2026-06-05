-- ===========================
-- LSP (load on file open)
-- ===========================
return {
    {
        "folke/trouble.nvim",
        opts = {},
        keys = {
            { "<leader>dt", "<cmd>Trouble diagnostics toggle<cr>", desc = "Trouble Toggle" },
        },
    },
}
