-- ===========================
-- Editor Enhancements
-- ===========================
return {
    {
        'kylechui/nvim-surround',
        keys = { 'ys', 'ds', 'cs', { 'S', mode = 'v' } },
        config = function()
            require('nvim-surround').setup({})
        end,
    },
    {
        'windwp/nvim-autopairs',
        dependencies = {
            'saghen/blink.cmp',
        },
        lazy = true,
    },
    {
        'numToStr/Comment.nvim',
        config = function ()
            require('Comment').setup({
                ignore = '^$',
                toggler = {
                    line = 'gcc',
                    block = 'gbc',
                },
            })
        end
    },
}
