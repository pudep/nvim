-- ===========================
-- Editor Enhancements
-- ===========================
return {
    {
        "echasnovski/mini.surround",
        version = "*",
        keys = {
            { "sa", mode = { "n", "v" } },
            { "sd", mode = { "n", "v" } },
            { "sr", mode = { "n", "v" } },
            { "sf", mode = { "n", "v" } },
            { "sF", mode = { "n", "v" } },
            { "sh", mode = { "n", "v" } },
            { "sn", mode = "n" },
        },
        opts = {
            mappings = {
                add = "sa",
                delete = "sd",
                replace = "sr",
                find = "sf",
                find_left = "sF",
                highlight = "sh",
                update_n_lines = "sn",
            }
        },
    },
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        cmd = "ToggleTerm",     -- also loaded on command
        keys = { "<A-t>" },     -- lazy-load trigger
        opts = {
            size = 15,
            open_mapping = "<A-t>",
            hide_numbers = true,
            shade_terminals = false,     -- keep this false because is  heavy
            -- shading_factor = 2,
            start_insert = true,
            insert_mappings = false,     -- tt works in insert mode too
            terminal_mappings = true,
            persist_size = true,
            direction = "horizontal",     -- no floating, ever
            close_on_exit = true,
            shell = vim.o.shell,
            auto_scroll = true,
        },
        vim.keymap.set("t", "<A-End>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    },
}
