-- ===========================
-- Editor Enhancements
-- ===========================
return {
    {
        'kylechui/nvim-surround',
        commit = 'fcfa7e0',
        event = 'VeryLazy',
        config = true,
    },
    {
        'windwp/nvim-autopairs',
        commit = '59bce2e',
        dependencies = {
            'saghen/blink.cmp',
        },
        lazy = true,
    },
    {
        'numToStr/Comment.nvim',
        commit = 'e51f2b1',
        keys = {
            { 'gcc', mode = 'n',          desc = 'Comment line' },
            { 'gc',  mode = { 'n', 'v' }, desc = 'Comment' },
        },
    },
}
