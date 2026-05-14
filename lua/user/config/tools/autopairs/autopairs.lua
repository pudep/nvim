local npairs = require('nvim-autopairs')

npairs.setup({
    check_ts = true,
    ts_config = {
        lua = { 'string', 'source' },
        javascript = { 'string', 'template_string' },
        typescript = { 'string', 'template_string' },
        java = false,
    },

    disable_filetype = {
        'TelescopePrompt',
        'spectre_panel',
        'vim',
    },
    disable_in_macro         = true,
    disable_in_visualblock   = false,
    disable_in_replace_mode  = true,

    -- %w removed: was blocking <> before word chars (e.g. Vec<T>)
    ignored_next_char = [=[[%%%'%[%"%.%`%$]]=],
    enable_moveright           = true,
    enable_check_bracket_line  = true,
    enable_bracket_in_quote    = true,
    enable_afterquote          = true,

    map_cr  = true,
    map_bs  = true,
    map_c_w = false,
    map_c_h = false,

    fast_wrap = {
        map              = '<M-e>',
        chars            = { '{', '[', '(', '"', "'", '<' },
        pattern          = [=[[%'%"%>%]%)%}%,]]=],
        end_key          = '$',
        keys             = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma      = true,
        highlight        = 'PmenuSel',
        highlight_grey   = 'LineNr',
        offset           = 0,
        manual_position  = true,
    },
})

-- ============================================
-- LOAD RUST-SPECIFIC RULES
-- ============================================
local ok, lang_rules = pcall(require, 'user.config.tools.autopairs.autopair_rule')
if ok then
    lang_rules.setup(npairs)
else
    vim.notify(
        'Could not load autopairs rules',
        vim.log.levels.WARN
    )
end

-- ============================================
-- KEYMAPS
-- ============================================

vim.keymap.set('n', '<leader>up', function()
    if npairs.state.disabled then
        npairs.enable()
        vim.notify('Autopairs enabled', vim.log.levels.INFO)
    else
        npairs.disable()
        vim.notify('Autopairs disabled', vim.log.levels.WARN)
    end
end, { desc = 'Toggle autopairs' })

vim.keymap.set('n', '<leader>uP', function()
    local line = vim.fn.getline('.')
    local col  = vim.fn.col('.')
    local char = line:sub(col, col)
    print('Char:', char)
    print('Rules:', vim.inspect(npairs.get_rule(char)))
end, { desc = 'Debug autopairs rules' })

-- ============================================
-- PERFORMANCE: DISABLE FOR LARGE FILES
-- ============================================

vim.api.nvim_create_autocmd('BufReadPre', {
    callback = function()
        local ok_stat, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
        if ok_stat and stats and stats.size > 500000 then
            npairs.disable()
            vim.notify('Autopairs disabled for large file', vim.log.levels.INFO)
        end
    end,
})

