-- 1. Load blink.cmp
vim.keymap.set("n", "<leader>lob", "<cmd>Lazy load blink.cmp<cr>", { desc = "Lazy load blink.cmp" })

-- 2. Load dressing.nvim
vim.keymap.set("n", "<leader>lod", "<cmd>Lazy load dressing.nvim<cr>", { desc = "Lazy load dressing.nvim" })

-- 3. Load indent-blankline.nvim
vim.keymap.set("n", "<leader>loi", "<cmd>Lazy load indent-blankline.nvim<cr>", { desc = "Lazy load indent-blankline.nvim" })

-- 4. Load all three at once
vim.keymap.set("n", "<leader>loa", "<cmd>Lazy load blink.cmp dressing.nvim indent-blankline.nvim<cr>", { desc = "Lazy load all three plugins" })

vim.keymap.set("n", "<leader>lot", "<cmd>Lazy load nvim-treesitter<cr>", { desc = "Lazy load nvim-treesitter" })
