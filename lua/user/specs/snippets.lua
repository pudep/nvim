-- ===========================
-- Snippets
-- ===========================
return {
    {
        'rafamadriz/friendly-snippets',
        commit = '6cd7280',
        lazy = true
    },
    {
        'L3MON4D3/LuaSnip',
        commit = '5a1e392',
        lazy = true,
        dependencies = {
            'rafamadriz/friendly-snippets',
        },
    },
}
