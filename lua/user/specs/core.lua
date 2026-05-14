-- ===========================
-- Core Dependencies (lazy loaded)
-- ===========================
return {
    {
        'nvim-lua/plenary.nvim',
        commit = '74b06c6',
    },
    {
        'MunifTanjim/nui.nvim',
        commit = 'de74099',
        lazy = true
    },
    {
        'nvim-tree/nvim-web-devicons',
        commit = '4fc505a',
        lazy = true
    },
    {
        'nvim-neotest/nvim-nio',
        commit = '21f5324',
        lazy = true
    },
}
