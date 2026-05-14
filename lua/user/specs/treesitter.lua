-- ===========================
-- Treesitter (load on file open)
-- ===========================
return {
    {
        'nvim-treesitter/nvim-treesitter',
        commit = '4916d65',
        event = 'BufReadPre',
        build = ':TSUpdate',
    },
}
