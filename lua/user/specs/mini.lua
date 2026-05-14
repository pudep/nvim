-- ===========================
-- Mini.nvim Suite
-- ===========================
return {
    {
        'nvim-mini/mini.notify',
        commit = '29ec27f',
    },
    {
        'nvim-mini/mini.indentscope',
        version = false, -- wait for stable versions for better stability
    },
    {
        'echasnovski/mini.move',
        commit = '4d21420',
        config = function()
            require('mini.move').setup({
                mappings = {
                    -- Visual mode (block moving)
                    left       = '<A-Left>',
                    right      = '<A-Right>',
                    down       = '<A-Down>',
                    up         = '<A-Up>',
                    -- Normal mode (line moving)
                    line_left  = '<A-Left>',
                    line_right = '<A-Right>',
                    line_down  = '<A-Down>',
                    line_up    = '<A-Up>',
                },
                options = {
                    reindent_linewise = true, -- auto re-indent when moving
                },
            })
        end,
    },
    {
        'echasnovski/mini.icons',
        commit = 'bac6317',
        version = false,
        lazy = true
    },
}
